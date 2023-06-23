class Millet < Formula
  desc "Language server for Standard ML (SML)"
  homepage "https://github.com/azdavis/millet"
  url "https://ghproxy.com/https://github.com/azdavis/millet/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "b920da82679f562845272f9a013cebef0b9d008fb354258907369e2c1ba39372"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/azdavis/millet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "846699f33469202acd82d811f6fd9b9cd0612d3f7e85d68a08842a315a6a8d31"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94bf7ea49655977b708cfa7a1d25a2253e436d8e37d032ba8b22f0127fac59dd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dcc7a476b467764573e358f77c36b1ece8304a4d472778aba58cc45daa53917e"
    sha256 cellar: :any_skip_relocation, ventura:        "a0bc196dcf091d220931328d2c1bcdc156537f2e1be6746130a7ad55b5268e17"
    sha256 cellar: :any_skip_relocation, monterey:       "b14d2d8b8a9ce8a6e67e07db93b76d59256439516e4a29b3982d603724761775"
    sha256 cellar: :any_skip_relocation, big_sur:        "b456b0825497f9d48a7309ddb71e2f483f976f67211b599aeb972bb716dca6c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6672487479dfe136a441d9987cb6fa2423dafcc0382b4d22331fc886aa35d44b"
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