# Requests like `find one`.
module DynFork::Commons::QOne
  extend self

  # Finds the document and converts it to a Model instance.
  # <br>
  # For more details, please check the official MongoDB documentation:
  # <br>
  # https://docs.mongodb.com/manual/reference/command/find/
  def find_one_to_instance(
    filter = BSON.new,
    sort = nil,
    projection = nil,
    hint : String | H? = nil,
    skip : Int32? = nil,
    comment : String? = nil,
    max_time_ms : Int64? = nil,
    read_concern : ReadConcern? = nil,
    max = nil,
    min = nil,
    return_key : Bool? = nil,
    show_record_id : Bool? = nil,
    oplog_replay : Bool? = nil,
    no_cursor_timeout : Bool? = nil,
    allow_partial_results : Bool? = nil,
    collation : Collation? = nil,
    read_preference : ReadPreference? = nil,
    session : Session::ClientSession? = nil
  ) : self?
    # Get collection for current model.
    collection : Mongo::Collection = DynFork::Globals.cache_mongo_database[
      @@meta.not_nil![:collection_name]]
    #
    if doc : BSON? = collection.find_one_to_instance(
         filter: filter,
         sort: sort,
         projection: projection,
         hint: hint,
         skip: skip,
         comment: comment,
         max_time_ms: max_time_ms,
         read_concern: read_concern,
         max: max,
         min: min,
         return_key: return_key,
         show_record_id: show_record_id,
         oplog_replay: oplog_replay,
         no_cursor_timeout: no_cursor_timeout,
         allow_partial_results: allow_partial_results,
         collation: collation,
         read_preference: read_preference,
         session: session,
       )
      return self.new.refrash_fields doc
    end
    #
    nil
  end
end
