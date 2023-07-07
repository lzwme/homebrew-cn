class Millet < Formula
  desc "Language server for Standard ML (SML)"
  homepage "https://github.com/azdavis/millet"
  url "https://ghproxy.com/https://github.com/azdavis/millet/archive/refs/tags/v0.12.4.tar.gz"
  sha256 "0995b20a98b1ee148de1dd50c756359ae984f18f4f61c0a69d72ec7e46b2f557"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/azdavis/millet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "359ba501fd70a9434a4bd618b327bfd72fd26c08dd81d15dde859912b28ab3ba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d7501b6354dd4a41409f507c2495ef04475cc7cfe284cddd77ee2923ba0bb2a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "61437393e23c3dff7fcb65881e64e6b5883081179a50b2f9bbc9aa4361ebd945"
    sha256 cellar: :any_skip_relocation, ventura:        "06748690e7d88c518ec6b107a2ec40e5e256ce41a586fa04521941df76be3592"
    sha256 cellar: :any_skip_relocation, monterey:       "5316a094d891c161bdf400e9d477ddc541f1fa86fcb1ec25ca578ab7016f3ce6"
    sha256 cellar: :any_skip_relocation, big_sur:        "63dccb0bc56a0f3f7ad536e9bdb7ff17eb25cc0ddcaa81fcaa72ef6f6127e220"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9afee75c238c441fcb43f97d6be4f1b6d1d63d60654a1aaf1a10c296d6803fd"
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