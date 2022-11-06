import fetch from "node-fetch"

export class CacheableFetch {
  cache = new Map()

  async get(endpoint){
    if(this.cache.has(endpoint)){
      return {
        data: this.cache.get(endpoint),
        status: 'cached'
      }
    }

    const result = await fetch(endpoint)
    const data = await result.json()

    this.cache.set(endpoint, data)

    return {
      data: data,
      status: 'first time'
    }
  }

  invalidate(path){
    this.cache.delete(path)
  }
}
