class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https:github.comcargo-binscargo-binstall"
  url "https:github.comcargo-binscargo-binstallarchiverefstagsv1.11.2.tar.gz"
  sha256 "cbb57ec964aa4aaf77f0f1ada3820b0172099396069fbc1639cebd527eb646b5"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c74ae85af83cce0119e596bb321abcbdcfe58cae0361bbe3d4c0703cbcaf1fe8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71254bbaaef198cc50e19127fb8ae8ee54102a290dc2be6c019e6760c70c0fc9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "211e48a69cc4a79aea2d2bfc21160f757712231bbcc89eaa06d3fd2d373f9464"
    sha256 cellar: :any_skip_relocation, sonoma:        "fcf9aca7c73b1f3676f0104f143a2e511018fd329024f42c3c8318a17ef3e7ea"
    sha256 cellar: :any_skip_relocation, ventura:       "96d6bb007d2dbcb0d2903127eea4864c28a51f7b49ddce181c3764c8419d6f68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a858f8b1d88577d3f5873ad15c9e9e207218acada5382e2cec8692a644b17ddd"
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