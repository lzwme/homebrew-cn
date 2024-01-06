class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https:github.comonflowcadence"
  url "https:github.comonflowcadencearchiverefstagsv0.42.7.tar.gz"
  sha256 "498271a2e4aded15e07ffa0fb5d2b8274aed2bbb27d9ebdb4a572fc22075647c"
  license "Apache-2.0"
  head "https:github.comonflowcadence.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a761fb2d3ce60fa1df216dc9a2c17864539dc60900ddc7daa21e0517ec43cc13"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b1185e8d4096d5b6cb84e1e2be8c323ceebba02a49b5c3c5f0978cf9ba259c3c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9abda5cd4468bddd5378e04ed7a0ebbe1ef61e7e908455a147a4b9f1c7857963"
    sha256 cellar: :any_skip_relocation, sonoma:         "cb330232c55b3a140b002f87d7e6198d3c03a9f5b0add3a0fdcea62ae3fd1cac"
    sha256 cellar: :any_skip_relocation, ventura:        "6947fb9f2f9353d1980748277295d466f9240fc4eadd910eeacbd68231ae5359"
    sha256 cellar: :any_skip_relocation, monterey:       "60a5f26c9d94502db101160087b30ed6d4e08d45f91061f7c03e9a428a373eae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1f08de6f0bccc3b0f3af5f8a7afd28c705a48c2a4ee2690daec3fb5f75402b0"
  end

  depends_on "go" => :build

  conflicts_with "cadence-workflow", because: "both install a `cadence` executable"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".runtimecmdmain"
  end

  test do
    (testpath"hello.cdc").write <<~EOS
      pub fun main(): Int {
        return 0
      }
    EOS
    system "#{bin}cadence", "hello.cdc"
  end
end