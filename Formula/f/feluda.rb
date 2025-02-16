class Feluda < Formula
  desc "Detect license usage restrictions in your project"
  homepage "https:github.comanistarkfeluda"
  url "https:github.comanistarkfeludaarchiverefstags1.3.0.tar.gz"
  sha256 "bd04174970289dd7636bffdff1ca9f275d205a084e1bea6cc8255a3d08e34c8b"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4ade29a11d407a76a8a3dcb063f66ee1892e92280d5198ff7e1830f048e52d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f84090458eff4c02e7a3d79b56a157b19abcee483f749778eb8d8a5e420bad4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2d2e97928d083344aeabfb42eb3b5e15ef651ef5ef4cf775a5f614cf7272a8e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "3851de57965b8cdf75686f653fbdd164f3759e803992911776e9965b74c82a24"
    sha256 cellar: :any_skip_relocation, ventura:       "86593140ef88c4fa7f154b71cfe9c5ef2407764bb20f812c9b8f5e8a7108ba41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "183ab11d5cb7756ab03d2a70e67f8121e9be0fd370ca194b365eaca222d9d631"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}feluda --version")

    output = shell_output("#{bin}feluda --path #{testpath} 2>&1", 1)
    assert_match "Unable to detect project type", output
  end
end