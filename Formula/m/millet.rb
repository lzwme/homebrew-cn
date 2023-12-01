class Millet < Formula
  desc "Language server for Standard ML (SML)"
  homepage "https://github.com/azdavis/millet"
  url "https://ghproxy.com/https://github.com/azdavis/millet/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "c4b9e26cf40641a4bbe0e2904284ef2283a18385045fec7308ee478ea39996b2"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/azdavis/millet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "875440ca546959dce4f7b43a05e2417848cf9705371f5e043c639716cb97a546"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b3d40554507f6bca1096c416948f32c711c9934028b470305543b03419c6476f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "561392c8d440b46072f2703ac268487a7dedfcf7b175e8709f96eeb819fc59d3"
    sha256 cellar: :any_skip_relocation, sonoma:         "c602c57b0df751a0436d219dd809701ba206d45751d20270a3393d35236f7738"
    sha256 cellar: :any_skip_relocation, ventura:        "62c85b14ce9fd1d2fc607c74ccbd53502529c6d06ff7e4b8026fd9e65cce851d"
    sha256 cellar: :any_skip_relocation, monterey:       "7c86db1825c23753bae56dbaebc6ddf81c8d31eee30f17e28bebf74baf195220"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "800d8ab6a65b4fe6f6c2a854eee9fe48fa4a190a7aa9e85386ba43e7d9218375"
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