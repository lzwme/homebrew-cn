class Millet < Formula
  desc "Language server for Standard ML (SML)"
  homepage "https://github.com/azdavis/millet"
  url "https://ghproxy.com/https://github.com/azdavis/millet/archive/refs/tags/v0.12.8.tar.gz"
  sha256 "a13a63c9be5ea00294dfa20c1e59f7ccf1269d15c9a490756a25c2b94c16e0d1"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/azdavis/millet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "43f46609f2643a404617c14db115619749f97d3c8737d9ce13dfdd51a83c2071"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "308d0d7fcf5ce1878310fefff8c53bae79b3c58e088f2e41c405bd2583197dbe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b502a81804ba6b8e752a1183e19d6cb7757d25beeee6ff534363e73007eb37cb"
    sha256 cellar: :any_skip_relocation, ventura:        "0f3218b9a562560d4c5f869b3c5b5e704bb0350c3b509398d65dccfe02c078f0"
    sha256 cellar: :any_skip_relocation, monterey:       "002cee13ed0691f68f8809b7d737bb69fdf2f33f11260d1e783c2ca8b648d1ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d1b743439019bb3729a6c74081e798ae3569371ed9d78f640ebe2fce2007a11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86ae7f0a36548fce6e69d69c2776f4f87071e3cdaf4b916b2fa42298e27302a7"
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