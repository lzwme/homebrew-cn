class Millet < Formula
  desc "Language server for Standard ML (SML)"
  homepage "https://github.com/azdavis/millet"
  url "https://ghproxy.com/https://github.com/azdavis/millet/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "11fe3a99c1826815fe07df8ea9d967872f210937a294cd293586568945be1907"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/azdavis/millet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a29e1190af118842de97c3ac32b0e1d57293835d310b02fb596519efc1574a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40c3b6b6e27d41b841cb76d25a6776b079dc155f0875ebefe68e5b197cc67870"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "779c75cbeba801dddf1f45c310a30e1175058f18419168061adff77f4ad95590"
    sha256 cellar: :any_skip_relocation, ventura:        "f158785c1da26497adf62d123e5614bdc7b7acdbf46eb1881a0ac0c635e37894"
    sha256 cellar: :any_skip_relocation, monterey:       "42b9092e4d48ec04e0e84920069989c356ea6241ef49e73995d7368414bbb29d"
    sha256 cellar: :any_skip_relocation, big_sur:        "2b7e8c7496025e7b30be66b25285b12afe71555b6462cef53e563dc40f0b7cbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "206b2bef9032df6d79c8eeca3b95dc031fb21ede20804097c32b7227859e91ca"
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