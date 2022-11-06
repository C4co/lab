import test from 'ava'
import { CacheableFetch } from './cacheable.js'

let endpoint1 = 'https://baconipsum.com/api/?type=meat-and-filler'
let endpoint2 = 'https://baconipsum.com/api/?type=all-meat&paras=2&start-with-lorem=1'
let endpoint3 = 'https://baconipsum.com/api/?type=all-meat&sentences=1&start-with-lorem=1'

test('CacheableFetch: should have .cache, .get and .invalidate',  t => {
  const HTTP = new CacheableFetch()

  t.truthy(HTTP.cache)
  t.truthy(HTTP.get)
  t.truthy(HTTP.invalidate)
})

test('Should return correct status and cache size', async t => {
  const HTTP = new CacheableFetch()
  const res1 = await HTTP.get(endpoint1)
  const res2 = await HTTP.get(endpoint1)
  const res3 = await HTTP.get(endpoint2)

  t.is(res1.status, 'first time')
  t.is(res2.status, 'cached')
  t.is(res3.status, 'first time')

  t.is(HTTP.cache.size, 2)
})

test('Cached response data should be the same of uncached responde data', async t => {
  const HTTP = new CacheableFetch()
  const res = await HTTP.get(endpoint1)
  const resCached = await HTTP.get(endpoint1)

  t.is(res.status, 'first time')
  t.is(resCached.status, 'cached')

  t.deepEqual(resCached.data.join(), res.data.join())
})

test('Should store multiples requests', async t => {
  const HTTP = new CacheableFetch()
  await HTTP.get(endpoint1)
  await HTTP.get(endpoint2)
  await HTTP.get(endpoint3)

  t.is(HTTP.cache.size, 3)
})

test('Should get request by cache', async t => {
  const HTTP = new CacheableFetch()
  await HTTP.get(endpoint1)
  await HTTP.get(endpoint2)
  await HTTP.get(endpoint3)

  const res1 = await HTTP.get(endpoint1)
  const res2 = await HTTP.get(endpoint2)
  const res3 = await HTTP.get(endpoint3)

  t.is(res1.status, 'cached')
  t.is(res2.status, 'cached')
  t.is(res3.status, 'cached')
})

test('Should invalidate a request cached', async t => {
  const HTTP = new CacheableFetch()

  const res1 = await HTTP.get(endpoint1)
  t.is(res1.status, 'first time')

  const res2 = await HTTP.get(endpoint1)
  t.is(res2.status, 'cached')

  HTTP.invalidate(endpoint1)

  const res3 = await HTTP.get(endpoint1)
  t.is(res3.status, 'first time')
})
