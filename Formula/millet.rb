class Millet < Formula
  desc "Language server for Standard ML (SML)"
  homepage "https://github.com/azdavis/millet"
  url "https://ghproxy.com/https://github.com/azdavis/millet/archive/refs/tags/v0.12.6.tar.gz"
  sha256 "edb7535a00c273829c2aee91b3585a72d1bffdf73a97dc3d1365c8b7f7902fa3"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/azdavis/millet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1469d008db7a7a8b62c77b76b32dd71949d7e01725ec37b13cbb0a0dac95682"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c98c94b9947a22df256406d20ff72108881bb56bb11488ac07f5d17d770359ee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "94c24a8c532aa3bfe786880872fa87c107e0ba73ae434d01ba087fdf69e10de1"
    sha256 cellar: :any_skip_relocation, ventura:        "5dd8209484c320ec607724d66a5def1cf9dc62687fe67f445c266a56a347af51"
    sha256 cellar: :any_skip_relocation, monterey:       "68563ab9706e20f18ad94b6f8d5f4fb34aa3de6a833f9fc78fb8c3aa90e75253"
    sha256 cellar: :any_skip_relocation, big_sur:        "ff77124d946b0e608369bfd8da38d211084685e9bc81d4fa528f5d86afc3ff69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "718e58c7b3ec61b786c554f71065c0d053e38aba2aa7e1d80857846ee26a4d07"
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