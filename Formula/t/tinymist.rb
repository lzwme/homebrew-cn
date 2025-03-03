class Tinymist < Formula
  desc "Language server for Typst"
  homepage "https:myriad-dreamin.github.iotinymist"
  url "https:github.comMyriad-Dreamintinymistarchiverefstagsv0.13.4.tar.gz"
  sha256 "ec3a8a6a33c24bb5b6c890f21a47de27b6486f61187c172e7736935adf94d91c"
  license "Apache-2.0"
  head "https:github.comMyriad-Dreamintinymist.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c864292bb50535b1c8901ea42e45276ee6d99ff0b78d8fe3a6e212234a7f6b98"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1eef5c1d68a9814611f31e7e4004d094cc20e858c0cfc7ed5896f1263edf2f14"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "54173f060790d1be00877eaceddf64ccea05d8a2e038c006909706b48955ad8f"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2e6a8713929c469b343a2547259dfaf37865e9a288d7fc3dd8918394a5ccf26"
    sha256 cellar: :any_skip_relocation, ventura:       "2adb5cb3b9a964d573bc1c3a6bd5fab87fdba08e4734326079689e92c542019d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab273f0c42cb644c0d0c208117b27a37627685e0ec8d1a86fea55ec59b64756c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratestinymist")
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
    output = IO.popen(bin"tinymist", "w+") do |pipe|
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