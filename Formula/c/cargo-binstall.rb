class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https:github.comcargo-binscargo-binstall"
  url "https:github.comcargo-binscargo-binstallarchiverefstagsv1.12.2.tar.gz"
  sha256 "a0e1aad27e6409006be8b7b90d3ed258cb5109539d7fbd3e961987f40bbb5b6b"
  license "GPL-3.0-only"
  head "https:github.comcargo-binscargo-binstall.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70a01e91163a5f0617a6439dce80d28aa37c926521ed26a14eeca9b07230acdc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5294c06612037958c2fafa42c27e43fa6e2cc460d4e0835af857df45e01080c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "39c3d0f1e384d5f7ada53baa88024ddca401dee48131831190144bece0cec381"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e841566128ac9a149b2881df4d2f8e2dbfc962544438be8cf4fa95670502c5c"
    sha256 cellar: :any_skip_relocation, ventura:       "45a995f8707fe91ee5e81b557919d9ad9c26b69fb351b842fb83ac66c821ff4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "892c7fd2b3bfd410655e65e4474f63e3dd83a20584eaa2fd56cc7d3e24584400"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratesbin")
  end

  test do
    output = shell_output("#{bin}cargo-binstall --dry-run radio-sx128x")
    assert_match "resolve: Resolving package: 'radio-sx128x'", output

    assert_equal version.to_s, shell_output("#{bin}cargo-binstall -V").chomp
  end
end