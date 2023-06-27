class Millet < Formula
  desc "Language server for Standard ML (SML)"
  homepage "https://github.com/azdavis/millet"
  url "https://ghproxy.com/https://github.com/azdavis/millet/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "1fbbd5d54410a70f172e96eacca8523dda28b680bb74df25ce208f82f6e36601"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/azdavis/millet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c225b25fbe39b340ae028638427746a61cff94d23075e06420b5b630aaa295a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b3e6614b72863401ed781227f7d3866d35a7d691228b3fa8a67796ba29397af"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b4d435d1e706062953c194354ce77f469030328c87022e2c1215fd448cfd1a91"
    sha256 cellar: :any_skip_relocation, ventura:        "92e7fe58246eff35e8290db9473ba26084fd95fee4f7e3f0e412e6a46a31bfe1"
    sha256 cellar: :any_skip_relocation, monterey:       "2dd8da8f876d1b8e1fb30df7b80006ed20bdf6a1ea2f0cdf8be568ef1fe03871"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f585e414d031b35a613e00cf0bf40afbf5d961cfd6a0ad5a2d2b9e3cebb37a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f9d3a2bac0054b78bbf288e8ba7bb48eb5f696c6e0a0d85a24f57dd999153c8"
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