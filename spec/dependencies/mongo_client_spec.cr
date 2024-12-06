require "../spec_helper"

# https://github.com/elbywan/cryomongo
describe "Cryomongo" do
  it "=> initialize mongo client", tags: "mongo_client" do
    # Create a Mongo client.
    # uri : String = ENV["MONGODB_URI"]? || "mongodb://localhost:27017"
    client : Mongo::Client = Mongo::Client.new

    # Data for test.
    database_name = "test_pcSenRPaSdaUiIjZ"
    collection_name = "test_collection_name"

    # Get database and collection.
    database = client[database_name]
    collection = database[collection_name]

    # Delete database before test.
    # (if the test fails)
    Spec::Support.delete_test_db(database).should be_nil
    # Let's check the result of the delete_test_db method.
    cursor = database.list_collections("name_only": true)
    elements = cursor.to_a
    elements.size.should eq(0)

    # Perform crud operations.
    collection.insert_one({one: 1})
    collection.replace_one({one: 1}, {two: 2})
    bson = collection.find_one({"two" => 2})
    bson.not_nil!["two"].should eq(2)
    collection.count_documents.should eq(1)
    collection.delete_one({two: 2})
    collection.count_documents.should eq(0)
    #
    collection.insert_one({one: 1, two: 2})
    bson = collection.find_one({one: 1})
    bson.not_nil!["one"].should eq(1)
    bson.not_nil!["two"].should eq(2)
    collection.count_documents.should eq(1)
    collection.update_one({one: 1}, {"$set": {two: 3}})
    bson = collection.find_one({one: 1})
    bson.not_nil!["one"].should eq(1)
    bson.not_nil!["two"].should eq(3)
    collection.count_documents.should eq(1)
    collection.delete_one({two: 3})
    collection.count_documents.should eq(0)
    #
    cursor = database.list_collections("name_only": true)
    elements = cursor.to_a
    elements.size.should eq(1)

    # Delete database after test.
    Spec::Support.delete_test_db(database).should be_nil
    # Let's check the result of the delete_test_db method.
    cursor = database.list_collections("name_only": true)
    elements = cursor.to_a
    elements.size.should eq(0)

    # The overwhelming majority of programs should use a single client and should not bother with closing clients.
    # Otherwise, to free the underlying resources a client must be manually closed.
    client.close
  end
end
