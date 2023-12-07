class Millet < Formula
  desc "Language server for Standard ML (SML)"
  homepage "https://github.com/azdavis/millet"
  url "https://ghproxy.com/https://github.com/azdavis/millet/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "f0a93af5b546a6da95570f825c4e6a13f0cdc47449949d26ac0530b10dbe1887"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/azdavis/millet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "37a87d843177c4e0611f9b0fbcded9b8f3475d42552ec5b63acc1df0d5f4eb13"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97fdb38dd59bbad5a66871f1a763d444357a61d64ac4947118b7a7a273977189"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d20ed903f73b30bec1c2737d2cd2d8aea7a9246ba2014efd5d5c86308c2f61a8"
    sha256 cellar: :any_skip_relocation, sonoma:         "9450837e9b72c08e0ed6d5fdb270591be1d69fb5629ace439de7cf258007babf"
    sha256 cellar: :any_skip_relocation, ventura:        "0d551914fdeaf72ef69bdadfedbfb7696c31213f530534a562a7fd3dafcca639"
    sha256 cellar: :any_skip_relocation, monterey:       "7fa42bee98476f4c9ca12b9d5fe46b2fbe84985730cf79e363e954d0588b0b66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21c1663bb1430d033193785c5a415f0fda863ee8fc4ae8e7b0310d69de1618f8"
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