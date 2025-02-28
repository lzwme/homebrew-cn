class Tinymist < Formula
  desc "Language server for Typst"
  homepage "https:myriad-dreamin.github.iotinymist"
  url "https:github.comMyriad-Dreamintinymistarchiverefstagsv0.13.2.tar.gz"
  sha256 "c97ac0d2f303e3e2b2224d34f75f26b67d623fe40f538929fa5108c1ef1486b8"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "883ea968da01335c609b8fe47664cbd9c0dac6076a3e096abd58e0b8e1cde95a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0254c8422852f1d50f82983fbc74d29940c2f1f632c2837f45251376701fbe83"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5c9cce4f6a6a9fd300d77d8f53ee1015e91dac57b3909a5ae7ff4189bc7bafe8"
    sha256 cellar: :any_skip_relocation, sonoma:        "5504f1d2aff116e9aa91e05402adae66c5e5ceda975d1188a97745daedf8b581"
    sha256 cellar: :any_skip_relocation, ventura:       "75d07b6aab899f1a8b1c11488033bb8729c0ca2d750058599c1c84c33202ee36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01d45b20879140ba55cfed2c9e1fa91fbcac7e5b69ace3f7ee821b0803da01a7"
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