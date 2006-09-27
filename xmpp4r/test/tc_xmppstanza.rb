#!/usr/bin/ruby

$:.unshift '../lib'

require 'test/unit'
require 'socket'
require 'xmpp4r/rexmladdons'
require 'xmpp4r/xmppstanza'
require 'xmpp4r/iq'
include Jabber

class XMPPStanzaTest < Test::Unit::TestCase

  ##
  # Hack: XMPPStanza derives from XMPPElement
  # which enforces element classes to be named at declaration time
  class MyXMPPStanza < XMPPStanza
    name_xmlns 'stanza', ''
  end

  def test_from
    x = MyXMPPStanza::new
    assert_equal(nil, x.from)
    assert_equal(x, x.set_from("blop"))
    assert_equal("blop", x.from.to_s)
    x.from = "tada"
    assert_equal("tada", x.from.to_s)
  end

  def test_to
    x = MyXMPPStanza::new
    assert_equal(nil, x.to)
    assert_equal(x, x.set_to("blop"))
    assert_equal("blop", x.to.to_s)
    x.to = "tada"
    assert_equal("tada", x.to.to_s)
  end

  def test_id
    x = MyXMPPStanza::new
    assert_equal(nil, x.id)
    assert_equal(x, x.set_id("blop"))
    assert_equal("blop", x.id)
    x.id = "tada"
    assert_equal("tada", x.id)
  end

  def test_type
    x = MyXMPPStanza::new
    assert_equal(nil, x.type)
    assert_equal(x, x.set_type("blop"))
    assert_equal("blop", x.type)
    x.type = "tada"
    assert_equal("tada", x.type)
  end

  def test_import
    x = MyXMPPStanza::new
    x.id = "heya"
    q = x.add_element("query")
    q.add_namespace("about:blank")
    q.add_element("b").text = "I am b"
    q.add_text("I am text")
    q.add_element("a").add_attribute("href", "http://home.gna.org/xmpp4r/")
    x.add_text("yow")
    x.add_element("query")

    assert_raise(RuntimeError) { iq = Iq.import(x) }
    x.name = 'iq'
    iq = Iq.import(x)
    
    assert_equal(x.id, iq.id)
    assert_equal(q.to_s, iq.query.to_s)
    assert_equal(x.to_s, iq.to_s)
    assert_equal(q.namespace, iq.queryns)
  end

  def test_error
    x = MyXMPPStanza::new
    assert_equal(nil, x.error)
    x.typed_add(REXML::Element.new('error'))
    assert_equal('<error/>', x.error.to_s)
    assert_equal(Error, x.error.class)
  end
end