class Millet < Formula
  desc "Language server for Standard ML (SML)"
  homepage "https://github.com/azdavis/millet"
  url "https://ghproxy.com/https://github.com/azdavis/millet/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "b3fd88956828f621d328fb835370441bf5a00a87eb28845b5e0705759ed24d0e"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/azdavis/millet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "485619dbb9e118f4cb49a273bd59823cdd52e611d1bc78dd713d9719624f9b59"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8310e58ee1fb49269e557170f28054efcd1a91f914a1029dfa664ed08b64d703"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9cd3ad043a794a7148ca1e178bcf57f060bc7bcf0149f0b1dab2e55a77b4174c"
    sha256 cellar: :any_skip_relocation, ventura:        "a15824af660c7a0d650b3f0a54989ba9142a24a64628e44d63dd4e173fe4fae9"
    sha256 cellar: :any_skip_relocation, monterey:       "ea6371e06f6c478306f6f7b7c9c96b468f060d96e2164be228011e02e94bbedf"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a884a36e653c386859025768375d33164c59e0244d24553f86f0f6538ab2638"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6223caf494f62b9a1ab56be77aefe709380ecd7524dd09c5351ddf3354acc0c"
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