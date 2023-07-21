class Millet < Formula
  desc "Language server for Standard ML (SML)"
  homepage "https://github.com/azdavis/millet"
  url "https://ghproxy.com/https://github.com/azdavis/millet/archive/refs/tags/v0.12.7.tar.gz"
  sha256 "c81a7b966019dbf18321e5f268a055dbb6453f9f6649f80b066434503d6bccd7"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/azdavis/millet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "210af04356958ee1a6af8e285d2e5c3137ce43c647e7f0f92c7758edbe70a8fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "483118712d7566d5610abd2ba57e821654fda8838f36d761abd82e6bff8bf29d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "82d827fbed9f4af4058fae55329766956a7430979c5d0bf56ad6948f6be310bd"
    sha256 cellar: :any_skip_relocation, ventura:        "1f8d58b4763c0f4afcc77eb42705ce932c5512aea2dc8fae7ff50bf080c66c48"
    sha256 cellar: :any_skip_relocation, monterey:       "72c3b145afcc887324a49842b366581f7aee197c16f81b09a93595db0856832b"
    sha256 cellar: :any_skip_relocation, big_sur:        "95cf380a4032f9ac425664c8fb670c4e4ab01a95a4df3162abdcf1420b6f28b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2aea795bffc8cae035663559e74a4fe824ea1086c6bfef24bec8cfa8d90c027f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/millet-ls")
  end

  test do
    initialize_request = { jsonrpc: "2.0",
                           id:      1,
                           method:  "initialize",
                           params:  { processId:    nil,
                                      rootUri:      nil,
                                      capabilities: {} } }

    initialized_notification = { jsonrpc: "2.0",
                                 method:  "initialized",
                                 params:  {} }

    shutdown_request = { jsonrpc: "2.0",
                         id:      2,
                         method:  "shutdown",
                         params:  {} }

    exit_notification = { jsonrpc: "2.0",
                          method:  "exit",
                          params:  {} }

    parse_content_length = lambda { |header_part|
      content_length_header = header_part.split("\r\n")[0]
      content_length = content_length_header.split(":")[1].to_i
      return content_length
    }

    read_header_part = lambda { |pipe|
      return pipe.readline("\r\n\r\n")
    }

    read_response = lambda { |pipe|
      header_part = read_header_part.call(pipe)
      content_length = parse_content_length.call(header_part)
      return JSON.parse(pipe.readpartial(content_length))
    }

    json_rpc_message = lambda { |msg|
      msg_string = msg.to_json
      return "Content-Length: #{msg_string.length}\r\n\r\n" + msg_string
    }

    send_message = lambda { |pipe, msg|
      pipe.write(json_rpc_message.call(msg))
    }

    IO.popen("#{bin}/millet-ls", "r+") do |pipe|
      pipe.sync = true

      # send initialization request
      send_message.call(pipe, initialize_request)

      # read initialization response
      response = read_response.call(pipe)
      assert_equal 1, response["id"]

      # send initialized notification
      send_message.call(pipe, initialized_notification)

      # send shutdown request
      send_message.call(pipe, shutdown_request)

      # read shutdown response
      response = read_response.call(pipe)
      assert_equal 2, response["id"]

      # send exit notification, which kills the child process
      send_message.call(pipe, exit_notification)

      pipe.close
    end

    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end