PubSub = () ->
  @_topics = {}
  @_wildcard_subscribers = []
  @


PubSub.prototype.subscribe = (topic, listener) ->
  if not @_topics.hasOwnProperty(topic)
    @_topics[topic] = []
  @_topics[topic].push(listener)


PubSub.prototype.subscribe_all = (listener) ->
  @_wildcard_subscribers.push(listener)


PubSub.prototype.publish = (topic, data) ->
  if @_topics.hasOwnProperty(topic)
    data = data || {}
    for cb in @_topics[topic]
      cb(data)
  #send out to wildcard subscribers (who subscribed via subscribe_all())
  for cb in @_wildcard_subscribers
    cb(topic, data)




EventBus = new PubSub()

module.exports = EventBus
