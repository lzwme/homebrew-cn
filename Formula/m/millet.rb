class Millet < Formula
  desc "Language server for Standard ML (SML)"
  homepage "https://github.com/azdavis/millet"
  url "https://ghproxy.com/https://github.com/azdavis/millet/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "897fcf8a610b31db18d64d14dc9ac6a5d2c64bc4659aa6b8e5ac658e60f5670c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/azdavis/millet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f3bde19ff7267742495c2dd9ba0f5c07907801098a38600c3cc6d3bf727b9ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95e93961129039b98d58e7676cd55b525dfed738f0b01343a08462c037f74ca2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e4c90ebb1ff11d2fdcd677f50da246ff969aa96da9b4ea1c5147a731de2842b7"
    sha256 cellar: :any_skip_relocation, ventura:        "e2ada3967f8e73096aeb9e75c5fb87533bb0d4750afc61d5aaf24abc90eb9248"
    sha256 cellar: :any_skip_relocation, monterey:       "fb783bf76c51c619054313420d01c27300268370b5a3531e874ed81aa04c0645"
    sha256 cellar: :any_skip_relocation, big_sur:        "5017da1dc0c316f817cae3e91f8ad64f81351a5b6fa23d2dc2bdf809cfaa245c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc3fefb40996e7c5aa94768dc8f9866280235b88d08231689c29809316dff3ce"
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