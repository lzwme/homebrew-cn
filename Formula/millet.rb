class Millet < Formula
  desc "Language server for Standard ML (SML)"
  homepage "https://github.com/azdavis/millet"
  url "https://ghproxy.com/https://github.com/azdavis/millet/archive/refs/tags/v0.9.5.tar.gz"
  sha256 "95dbb03159a0108a0e69707e1f66194af01c55c903161d87b85eb4ac6d3c6812"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/azdavis/millet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "842edb3aeba70cea9bfd7c34aca3f53575776e0b4de0f1099e62e9197aec4cbc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f527d1003c1953db3129929712d730d2b7ecca440370ec0923fb329917516181"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6eb7a3fe37888bb269057ec7fdf5640d99c0ae1aa882d01fbb0a688d70121704"
    sha256 cellar: :any_skip_relocation, ventura:        "dd59022555b81e6bc1d6060a0ad85abb85e5f5fbab1fef2f6e0bb5594a5530a0"
    sha256 cellar: :any_skip_relocation, monterey:       "b20c7260ad54fa7178ef866b46fff5459f2f5a6febc74a308b2e66d442970d93"
    sha256 cellar: :any_skip_relocation, big_sur:        "18f50412f810ba40cf0340b984142e6b0bdf30619fc04731f1dc72f75efceda5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1895a2cd0966920e9f3501ba684b056f34fa9f707ef92550e6424cad24068cbf"
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