class Millet < Formula
  desc "Language server for Standard ML (SML)"
  homepage "https://github.com/azdavis/millet"
  url "https://ghproxy.com/https://github.com/azdavis/millet/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "16b2b71b99f11c4d56f8792a26c979b4b6108ac5041efabe624c07bfe0738885"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/azdavis/millet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f2d116fa547bf0f3a78a539664ae5fe470412176e97f1fe8e426a51512fa43ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d2c27f65fa6f78be0d5e163c20421e5c0a407619f3425864189973bce570e84"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4211e4c62ba2d5d0656943aad4e10a7d189943211235a16a5094ced82511d7a4"
    sha256 cellar: :any_skip_relocation, ventura:        "08059d126feb671fbe2e0c7bad4370de7a0a4d68c40df93d764f16ed5c2d97c9"
    sha256 cellar: :any_skip_relocation, monterey:       "deed5c441a5343563290236db3a027bf257348b5c48d8898216e4a7bd00ed9da"
    sha256 cellar: :any_skip_relocation, big_sur:        "8db38449c2cdc841bc7a3582c0e55436fcc65ed8825d1228c79c86f58c7e63bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9dcc757b1c66105fd29d35d220e28f09548166e421167c6b45c6a3b0c8218ed0"
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