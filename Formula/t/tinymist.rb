class Tinymist < Formula
  desc "Language server for Typst"
  homepage "https:github.comMyriad-Dreamintinymist"
  url "https:github.comMyriad-Dreamintinymistarchiverefstagsv0.11.15.tar.gz"
  sha256 "12bdc89b200095033f9db8b8bb086662f3dd86f7fc432dd840f1c87839c103a2"
  license "Apache-2.0"
  head "https:github.comMyriad-Dreamintinymist.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "95671923090f6dd1d3e2f7b824ef1539e34ca9aa73f6b12f5153c8d9a35df481"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a8f63acb4fb81f0fcb60120f4cd7bbd9f07ae56fe00aca2f07f65b0003a4418a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ac86fccb1ed7b0ce60c3d897810c6a77732fc2573de2cb921b24fca1f3846b0"
    sha256 cellar: :any_skip_relocation, sonoma:         "50cc784ec8991ad39d6cef6c73787e97cd420df1c10b5fd7abe0be1df7252d3b"
    sha256 cellar: :any_skip_relocation, ventura:        "5e543de146c98dcc317bd3c093210ecacdff2765111464a43d59925a97d126a1"
    sha256 cellar: :any_skip_relocation, monterey:       "718be78197b79413f3984a5f48ca7be5d4b470736443ca4552e269600cec3e82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1908b60d124b5cc7b49285c963383b87b3d51688e818b9a81148d533c4fd8ca6"
  end

  depends_on "rust" => :build

  def install
    cd "cratestinymist" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON

    input = "Content-Length: #{json.size}\r\n\r\n#{json}"
    output = IO.popen("#{bin}tinymist", "w+") do |pipe|
      pipe.write(input)
      sleep 1
      pipe.close_write
      pipe.read
    end

    assert_match(^Content-Length: \d+i, output)
    json_dump = output.lines.last.strip
    assert_equal 1, JSON.parse(json_dump)["id"]
  end
end