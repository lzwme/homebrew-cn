class Millet < Formula
  desc "Language server for Standard ML (SML)"
  homepage "https://github.com/azdavis/millet"
  url "https://ghproxy.com/https://github.com/azdavis/millet/archive/refs/tags/v0.11.4.tar.gz"
  sha256 "fede597f06a23ed1900fceec83eadea2726801ee45c20d2f4d6fa6e8ce9f8b5a"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/azdavis/millet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "90943ef7b7850945c6c9a2e61062100ddfa20abbb271a362cb8cca8e78d2ca2c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "986fc694a283ab17b82e5c165a2f70ca6803fabf2ae2b32fa2b5a5267a23e820"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4ffa5d95c497c97b1718dce28bb75d5cd7fc253e9d971c56f072f70501f00a80"
    sha256 cellar: :any_skip_relocation, ventura:        "6fc3b7d40b57be0272798d098a9cc5ffb2bb299dbff7c9a5beaf16d6ccc842f4"
    sha256 cellar: :any_skip_relocation, monterey:       "a70057f1ff4fa3a307e18a937054b9799e48445821eee3a39094cc97f909fdcd"
    sha256 cellar: :any_skip_relocation, big_sur:        "64c99fee26ad84451286363c47bc1d68665fbe0d89aa10916c7e9ba987193ad2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72d3cb13b06f43782d77cc8c931f3b28a0d22e052c8e4efaa5339cad1ee71f72"
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