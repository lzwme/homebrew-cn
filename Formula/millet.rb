class Millet < Formula
  desc "Language server for Standard ML (SML)"
  homepage "https://github.com/azdavis/millet"
  url "https://ghproxy.com/https://github.com/azdavis/millet/archive/refs/tags/v0.12.5.tar.gz"
  sha256 "7d0d420a723041b53cde015e33757ba8468aefc0762dca5a060c2e090f0b415f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/azdavis/millet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3cbdb6ea4124217e751f0991dc97021adbbf05dbfa83324ccf148611a86e93d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b2676182a908dc0e4c62832f39a4cbd68655ad3e680c9def23af099fb96c7cb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2ac0e24f0ded415ff48f1da8b9f15b0b8437da8dc4a0d30c3e221b9c668cc0eb"
    sha256 cellar: :any_skip_relocation, ventura:        "37e8cf66f91d3f8cfaf7e0a100fc26d263257a93cf1f9a545c0293898488788a"
    sha256 cellar: :any_skip_relocation, monterey:       "cc86aca21818840173c10cd09511ff8f6451b878312b7d991fc3179a5424e39b"
    sha256 cellar: :any_skip_relocation, big_sur:        "7e8d2d5900ecf73359cd053195d77866a013461b780f2c0dadbd1480c501700b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c49224e4e710385f6e65bc27c8beeea8af3bc547d8f830d76234a06729cb5bd"
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