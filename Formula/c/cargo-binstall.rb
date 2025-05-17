class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https:github.comcargo-binscargo-binstall"
  url "https:github.comcargo-binscargo-binstallarchiverefstagsv1.12.5.tar.gz"
  sha256 "09dd754bda00b1a270e8d5794431fe6cc6f580410dcefa29e98f4d4679823019"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4cb84dd812e3878c557d5f71ef672060c913cfc90fb10348946c7d3a83678bf1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38a87dd4f4954fcdb66eb1a4ec4ee1cef0d7ceaafd3d6566606cbdb5e7cf784e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "88a6d94e79b2b569fd351c15e4d56d8230b18c9837dd1cdee0cb954139782034"
    sha256 cellar: :any_skip_relocation, sonoma:        "cfb9069f33fd6ca189d6806dc5a2d017f1213569b53b916a1afcd4a6ad3cc490"
    sha256 cellar: :any_skip_relocation, ventura:       "cc1f4b16ef345037fa2bd396e736bbfe326adda01ce9e56329ec129caf3ded59"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3221e17f438e454485a61f9ad12b22a5cb15c6bebcc72ddd0d34406c857e3e6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c22bc120d0add8321c976a396546f9453ce2ef722f7843eb7f8eb44ee5e2ee6"
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