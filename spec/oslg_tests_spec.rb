require "oslg"

RSpec.describe OSlg do
  let(:clss) { Class.new  { extend OSlg } }
  let(:cls2) { Class.new  { extend OSlg } }
  let(:modu) { Module.new { extend OSlg } }
  let(:mod2) { Module.new { extend OSlg } }

  it "can log within class instances" do
    expect(clss.clean!).to eq(clss::INFO)
    expect(clss.log(clss::INFO, "Logging within clss")).to eq(clss::INFO)

    expect(clss.status).to eq(clss::INFO)
    expect(clss.debug?).to be(false)
    expect(clss.info?).to be(true)
    expect(clss.warn?).to be(false)
    expect(clss.error?).to be(false)
    expect(clss.fatal?).to be(false)
    expect(clss.logs.is_a?(Array)).to be(true)
    expect(clss.logs.size).to eq(1)
    expect(clss.logs.first.is_a?(Hash)).to be(true)
    expect(clss.logs.first.key?(:level)).to be(true)
    expect(clss.logs.first[:level]).to eq(clss.status)
    expect(clss.logs.first.key?(:message))
    expect(clss.logs.first[:message]).to eq("Logging within clss")

    expect(cls2.setLevel(cls2::DEBUG)).to eq(cls2::DEBUG)
    expect(cls2.clean!).to eq(cls2::DEBUG)
    expect(cls2.log(cls2::WARN, "Logging within cls2")).to eq(cls2::WARN)

    expect(cls2.status).to eq(cls2::WARN)
    expect(cls2.debug?).to be(false)
    expect(cls2.info?).to be(false)
    expect(cls2.warn?).to be(true)
    expect(cls2.error?).to be(false)
    expect(cls2.fatal?).to be(false)
    expect(cls2.logs.is_a?(Array)).to be(true)
    expect(cls2.logs.size).to eq(1)
    expect(cls2.logs.first.is_a?(Hash)).to be(true)
    expect(cls2.logs.first.key?(:level)).to be(true)
    expect(cls2.logs.first[:level]).to eq(cls2.status)
    expect(cls2.logs.first.key?(:message))
    expect(cls2.logs.first[:message]).to eq("Logging within cls2")

    expect(cls2.clean!).to eq(cls2::DEBUG)                                  # without arguments
    expect(cls2.invalid.nil?).to be(true)
    expect(cls2.logs.empty?).to be(true)

    expect(cls2.clean!).to eq(cls2::DEBUG)
    expect(cls2.invalid(4, -1).nil?).to be(true) # 4 != method, -1 invalid order
    expect(cls2.logs.size).to eq(1)
    expect(cls2.logs.first.key?(:message))
    expect(cls2.logs.first[:message]).to eq("Invalid argument (4)")

    expect(cls2.clean!).to eq(cls2::DEBUG)
    expect(cls2.invalid(String, "string").nil?).to be(true)    # Class to String
    expect(cls2.logs.size).to eq(1)
    expect(cls2.logs.first.key?(:message))
    expect(cls2.logs.first[:message]).to eq("Invalid argument (String)")

    expect(cls2.clean!).to eq(cls2::DEBUG)
    expect(cls2.mismatch("String", Integer, "foo").nil?).to be(true) # i to s
    expect(cls2.logs.size).to eq(1)
    expect(cls2.logs.first.key?(:message))
    expect(cls2.logs.first[:message]).to eq("String? expecting Integer (foo)")

    expect(cls2.clean!).to eq(cls2::DEBUG)
    expect(cls2.mismatch(nil, nil).nil?).to be(true)       # nil or no arguments
    expect(cls2.logs.empty?).to be(true)

    expect(cls2.clean!).to eq(cls2::DEBUG)
    expect(cls2.mismatch("String", String, "foo").nil?).to be(true)  # mismatch?
    expect(cls2.logs.empty?).to be(true)

    expect(cls2.mismatch("String", Array, (1..60).to_a).nil?).to be(true) # to_a
    expect(cls2.logs.size).to eq(1)
    expect(cls2.logs.first.key?(:message))
    str = "String? expecting Array ([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, "
    expect(cls2.logs.first[:message].include?(str)).to be(true)

    expect(cls2.clean!).to eq(cls2::DEBUG)
    expect(cls2.hashkey({foo: 0}, "foo", "bar")).to be(nil)
    expect(cls2.logs.size).to eq(1)
    expect(cls2.logs.first.key?(:message))
    expect(cls2.logs.first[:message]).to eq("Hash doesn't hold key 'foo' (bar)")

    expect(cls2.clean!).to eq(cls2::DEBUG)
    expect(cls2.hashkey({foo: 0}, :foo, "bar")).to be(nil)
    expect(cls2.logs.empty?).to be(true)

    expect(cls2.clean!).to eq(cls2::DEBUG)
    expect(cls2.hashkey([0, 1], :foo, "bar")).to be(nil)
    expect(cls2.logs.size).to eq(1)
    expect(cls2.logs.first.key?(:message))
    expect(cls2.logs.first[:message]).to eq("Array? expecting Hash (bar)")

    expect(cls2.clean!).to eq(cls2::DEBUG)
    expect(cls2.empty("foo", "bar")).to be(nil)
    expect(cls2.logs.size).to eq(1)
    expect(cls2.logs.first.key?(:message))
    expect(cls2.logs.first[:message]).to eq("Empty 'foo' (bar)")

    expect(cls2.clean!).to eq(cls2::DEBUG)
    expect(cls2.empty({foo: 0}, :foo)).to be(nil)
    expect(cls2.logs.size).to eq(1)
    expect(cls2.logs.first.key?(:message))
    expect(cls2.logs.first[:message]).to eq("Empty '{:foo=>0}' (foo)")

    expect(cls2.clean!).to eq(cls2::DEBUG)
    expect(cls2.empty(nil, 0)).to be(nil)
    expect(cls2.logs.empty?).to be(true)

    expect(cls2.clean!).to eq(cls2::DEBUG)
    expect(cls2.zero("foo", "bar")).to be(nil)
    expect(cls2.logs.size).to eq(1)
    expect(cls2.logs.first.key?(:message))
    expect(cls2.logs.first[:message]).to eq("'foo' ~zero (bar)")

    expect(cls2.clean!).to eq(cls2::DEBUG)
    expect(cls2.zero({foo: 0}, :foo)).to be(nil)
    expect(cls2.logs.size).to eq(1)
    expect(cls2.logs.first.key?(:message))
    expect(cls2.logs.first[:message]).to eq("'{:foo=>0}' ~zero (foo)")

    expect(cls2.clean!).to eq(cls2::DEBUG)
    expect(cls2.zero(nil, 0)).to be(nil)
    expect(cls2.logs.empty?).to be(true)
  end

  it "can log within a Module" do
    modu.clean!
    modu.log(modu::INFO, "Logging within modu")

    expect(modu.status).to eq(modu::INFO)
    expect(modu.debug?).to be(false)
    expect(modu.info?).to be(true)
    expect(modu.warn?).to be(false)
    expect(modu.error?).to be(false)
    expect(modu.fatal?).to be(false)
    expect(modu.logs.is_a?(Array)).to be(true)
    expect(modu.logs.size).to eq(1)
    expect(modu.logs.first.is_a?(Hash)).to be(true)
    expect(modu.logs.first.key?(:level)).to be(true)
    expect(modu.logs.first[:level]).to eq(modu.status)
    expect(modu.logs.first.key?(:message))
    expect(modu.logs.first[:message]).to eq("Logging within modu")

    expect(mod2.setLevel(mod2::DEBUG)).to eq(mod2::DEBUG)
    expect(mod2.clean!).to eq(mod2::DEBUG)
    expect(mod2.log(mod2::WARN, "Logging within mod2")).to eq(mod2::WARN)

    expect(mod2.status).to eq(mod2::WARN)
    expect(mod2.debug?).to be(false)
    expect(mod2.info?).to be(false)
    expect(mod2.warn?).to be(true)
    expect(mod2.error?).to be(false)
    expect(mod2.fatal?).to be(false)
    expect(mod2.logs.is_a?(Array)).to be(true)
    expect(mod2.logs.size).to eq(1)
    expect(mod2.logs.first.is_a?(Hash)).to be(true)
    expect(mod2.logs.first.key?(:level)).to be(true)
    expect(mod2.logs.first[:level]).to eq(mod2.status)
    expect(mod2.logs.first.key?(:message))
    expect(mod2.logs.first[:message]).to eq("Logging within mod2")
  end
end
