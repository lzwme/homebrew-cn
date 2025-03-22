class Feluda < Formula
  desc "Detect license usage restrictions in your project"
  homepage "https:github.comanistarkfeluda"
  url "https:github.comanistarkfeludaarchiverefstags1.5.2.tar.gz"
  sha256 "7b79f5374bb6b1b1bdb4e8f2bd0bac5d52a66b4aed58cbd2fae7b6facf153701"
  license "MIT"
  head "https:github.comanistarkfeluda.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c5df88d79697c254985465ec47f99625bc65c858f8976ec45b6c65c5e33c6e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "703ad52e2af1363805527b485e3573ae70bf55cc71cd6c8564713b32a51cabb2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "561f6a0aa0ab59e8a491bc3a164690bdb5b6dc83dc74c5dd4bfb5bc83a472712"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a5a07d307f232d29941f8e15082759ca590dd138a1de3a5fb17fe94d1ddac86"
    sha256 cellar: :any_skip_relocation, ventura:       "98388541b0dacd5a380dbd22a7988526de0ae5f4af5618d1d08980b595eae691"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf7910a10eb9971f1c88ccb6ab5b26a6f0ec7af08c93cc5b38e9f64f17a7ebed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f312b11585d3df8518fb4de513efcf3d8d49b1875bc9436b230f03653835bb28"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}feluda --version")

    output = shell_output("#{bin}feluda --path #{testpath}")
    assert_match " All dependencies passed the license check!", output
  end
end