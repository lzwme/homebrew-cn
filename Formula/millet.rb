class Millet < Formula
  desc "Language server for Standard ML (SML)"
  homepage "https://github.com/azdavis/millet"
  url "https://ghproxy.com/https://github.com/azdavis/millet/archive/refs/tags/v0.12.2.tar.gz"
  sha256 "c487ac84ffed2b2509acfbf4695eeba0d8fbdcd67b6fff38fd2b29859800f1e0"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/azdavis/millet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "20ca0d7eb859c6a0b07b3a24c16d5070d43a7e0affd8d55be9333e81b1e4c891"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "999834fe0d22f3e3377d8f3202235980c79aa1c8e62f2889e0ae122dd2d25b15"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4220af4bc7b2316789d3926c092ca47bd29d5abea17b5371b89f8c71c6dccd0f"
    sha256 cellar: :any_skip_relocation, ventura:        "2a295847a6e9f056ac4de425ae8c4853a628e1b6f04d9290e26d07595c454468"
    sha256 cellar: :any_skip_relocation, monterey:       "ea9f8311bf13adb959ce5d201dc01e28d33fc93a5ab3e8cda5134782ecc2e52c"
    sha256 cellar: :any_skip_relocation, big_sur:        "47e9ba1c48a0ae352d1e40a69a375288666dd78dd8def1794db23a0644637532"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9817d9776354ccc6098e23b051018853c74ba6a24d73cfe9707effbacfff8df"
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