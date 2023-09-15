class Millet < Formula
  desc "Language server for Standard ML (SML)"
  homepage "https://github.com/azdavis/millet"
  url "https://ghproxy.com/https://github.com/azdavis/millet/archive/refs/tags/v0.13.3.tar.gz"
  sha256 "22e455bec83ac03bc916addb65f74a62c20635c8c42e9292a4df5023a97d2735"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/azdavis/millet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d2a3c0907502ded2d47c8b5cb43cfd79f83e330ac198a68bfd4c7bd8dd2a6543"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e967f54335877482e6280dc132b0d28ba827863e4dddbcba89a160d3af82947"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "04b5026a3a7e7c3362116c75fcbb98cf3bd816cdc8f69da112eed425211e57ee"
    sha256 cellar: :any_skip_relocation, ventura:        "b3f4f8248e0ae3a4fc4d90cf74fc7debe6cec1a8be2f33c72cdabd1db5797932"
    sha256 cellar: :any_skip_relocation, monterey:       "758717075b9b07c2e7989fa248ea17ee187d77f83b037c1af50f5edf06747746"
    sha256 cellar: :any_skip_relocation, big_sur:        "78770d5afce52aa1dac7c28c4febc015e8d64664a521a8dfab0385d83fcc0136"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e75c805553950b9b88192b4300ea185d4db93815a09549ca836f3fba6bd7b06d"
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