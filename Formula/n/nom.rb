class Nom < Formula
  desc "RSS reader for the terminal"
  homepage "https://github.com/guyfedwards/nom"
  url "https://ghfast.top/https://github.com/guyfedwards/nom/archive/refs/tags/v3.3.1.tar.gz"
  sha256 "84d5732d6725af5536ef07827427a14932de4a69d6bd6e0d3e7dbbea6c356bf1"
  license "GPL-3.0-only"
  head "https://github.com/guyfedwards/nom.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d8c372aa282554e0a7535c365a70d20efcb3e655066eaa187b0353e891c07c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "178680882d9f37bda41c06f10e4d95aae72fbbf2ff7c551c943e146da25a0d61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bce1c1f50909885c04d9f0f337e22ea9b7884ee5d82f65b8104105783197e6c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "c69cab94ae95e17c8156e57c74a1c882bcca492e38a9d0e2c2134ffcb28dabb9"
    sha256 cellar: :any,                 arm64_linux:   "c7934a593da2e8cd1896c160d48a5933d3fae7b687cb8437eb2ac078750c6854"
    sha256 cellar: :any,                 x86_64_linux:  "2bddd2019da5da0e59e1ea48911302af407e32c8c00fd27e26d8a077467c2519"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" # Required by `go-sqlite3`

    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/nom"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nom version")

    assert_match "configpath", shell_output("#{bin}/nom config")
  end
end