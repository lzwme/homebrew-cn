class Millet < Formula
  desc "Language server for Standard ML (SML)"
  homepage "https://github.com/azdavis/millet"
  url "https://ghproxy.com/https://github.com/azdavis/millet/archive/refs/tags/v0.13.2.tar.gz"
  sha256 "26ac769897cf8178b47b6235bd8745aaf25692d089f2856aa8829f6183b7829e"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/azdavis/millet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3873b38b56e837f54e3c4585c92a12b165e90d9bce45badcd1357f9daf085941"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3884bca63f10b0409c9ada05521f9886cf8f5e90e7cce73432419618d06d758f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f4d48dc51f13a85207d256bb1a26968b14763ba22bf1d392344c6587d468c25b"
    sha256 cellar: :any_skip_relocation, ventura:        "369be3274b8cb92de1cd5b606b0c4699649ae808e0c0e1a62edebe9452c6f9d9"
    sha256 cellar: :any_skip_relocation, monterey:       "f822bd3ed2cb837df2192220cf31880c5591beefa4bc9ebe7f6d01bdcba9e4e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "2359a99a8d303fdf5aeb240086434d190dbfbeda1e59371eda1effc2fadfca5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2059fd7175a04f1e5f1b8c2475c3d0c2b9c303515effa1b1965afbd6f8a760e0"
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