class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https:github.comcargo-binscargo-binstall"
  url "https:github.comcargo-binscargo-binstallarchiverefstagsv1.12.1.tar.gz"
  sha256 "d3606cb847464dc96540fa5cc2ea69a51ba997389d1c7686618bd07392fd7b3d"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "402baea0549bd94b87e5376c4a167fa25c8787f90a4995c94e921998e5e3aa57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "194cddd66d4bcf380cc671772cdbf038786334808c7174eeba86d40e65bfe014"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bc6700d351aca15516059850bca2c1bb9f0cc429c5d5d9221ed1971f153da9d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb1e7a64f4e2173e44a0b8eaddf38f300b7784c0623e69e08fd36b69e85e1a1b"
    sha256 cellar: :any_skip_relocation, ventura:       "fc95070965560705ffa7b3477b9ef0adafccaea2cbeb6600aa703d58b8371403"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02c406b77e3431bc51b0b82d25da72fde20e2c842e52fa3f2c440adc02f5b26f"
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