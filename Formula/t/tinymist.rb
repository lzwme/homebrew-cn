class Tinymist < Formula
  desc "Language server for Typst"
  homepage "https:myriad-dreamin.github.iotinymist"
  url "https:github.comMyriad-Dreamintinymistarchiverefstagsv0.13.8.tar.gz"
  sha256 "3d1ff8a58cafa3697453acb3e9bc52631f785d9f913e1afd14dcf6f6539f2bb1"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8aad0d204b89affd2131a43d0847417102f66b83588d3464052cf42bd2b6a172"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea3db7e0a288de7a9af906ad01b8dfcd2648132252faf087e14bb4204d3c3d0a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7fd45c8d2b490ce6751bef741fb07aef21a600f0c02db032708dd6009769b7d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "f852ab28075cc57291417741561672aeca879ff25aac2bd79c7cb804567809d5"
    sha256 cellar: :any_skip_relocation, ventura:       "70c97785b11d57610b5c30ef74c626ddd67a2bb9ba2a7d7a1b3b0d6e1c75b061"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c141a882130f931a29acf51e90bc7f223ca962c137d1ad53b2a14fc8ceb901e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec9ddb3edac83df0ea4b5911a97a56bef95f6f052438a4973506ee31c628af8e"
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