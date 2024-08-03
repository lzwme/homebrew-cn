class Millet < Formula
  desc "Language server for Standard ML (SML)"
  homepage "https:github.comazdavismillet"
  url "https:github.comazdavismilletarchiverefstagsv0.14.5.tar.gz"
  sha256 "5d89ddf540bdfa9b72f28be22a0cf4f57a65e6c09417c0b5cdf047f027fe06e1"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comazdavismillet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8d971ac07328aa008f3a5917ca7518c74292e3f83914fad21370243688dfba7a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fdf48297806fbfb92d63d94c15f451ced4ec93d586d64cf5a56b0f5ce98d3558"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b324b8ae869f52ffca0aa99270f115a8c0c65cc24a58b2317f51ee723e0e7996"
    sha256 cellar: :any_skip_relocation, sonoma:         "2dc16d6ca10b5429dc7404e69f80b872194acc70052c15dbbb5607c28de5ba85"
    sha256 cellar: :any_skip_relocation, ventura:        "5af127c36f90f3188221f8c4d2995762dfe1d4e9602cbabbc437c6487f25d769"
    sha256 cellar: :any_skip_relocation, monterey:       "61a4ab4c1ac44948204d236bf19368cdaa37bb63ccc7dac7a18704143160083e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55145d89cfbfd31075bdd14211fd011e1bb40ab36ae87d6924a4d8ad76b5561d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratesmillet-ls")
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
      content_length
    }

    read_header_part = lambda { |pipe|
      pipe.readline("\r\n\r\n")
    }

    read_response = lambda { |pipe|
      header_part = read_header_part.call(pipe)
      content_length = parse_content_length.call(header_part)
      JSON.parse(pipe.readpartial(content_length))
    }

    json_rpc_message = lambda { |msg|
      msg_string = msg.to_json
      "Content-Length: #{msg_string.length}\r\n\r\n" + msg_string
    }

    send_message = lambda { |pipe, msg|
      pipe.write(json_rpc_message.call(msg))
    }

    IO.popen(bin"millet-ls", "r+") do |pipe|
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