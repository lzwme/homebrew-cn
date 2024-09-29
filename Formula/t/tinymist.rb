class Tinymist < Formula
  desc "Language server for Typst"
  homepage "https:github.comMyriad-Dreamintinymist"
  url "https:github.comMyriad-Dreamintinymistarchiverefstagsv0.11.22.tar.gz"
  sha256 "ebb0fde8edca6daed57129a377616344284e1f870e48051ce5401814153d355c"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "badf41077c9f76def0cdb24348c247704fc8a24a2ae10b5d4276ec4d6d79bc50"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35c9bae7fd4df1b992ed0d5e54874001bed5f8d61da41aef4834f299f41a269e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8b944b8c45bc42a7adcbaeeb828f74ab332348a654455ea7ac35fe57e8c5d6f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "59180f2cb63309ff5ed3681baa87c7bf83798081a97ba0cd7ca65e766cb05380"
    sha256 cellar: :any_skip_relocation, ventura:       "5a6c8b0d6acafd103f0e27e0433590605eaaf48c3f35233e76e19f750c2c9ba5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1ad825ccf7aee6721cf6acd65edba12892b0b2c0175a063e444d29ddf8e424e"
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