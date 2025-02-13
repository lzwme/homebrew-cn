class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https:github.comcargo-binscargo-binstall"
  url "https:github.comcargo-binscargo-binstallarchiverefstagsv1.10.23.tar.gz"
  sha256 "2012b3d3ce88c6ea3d4927a1fc9377b7c33703cbf37ea7a2b33ac89e18a2bc54"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e32baf3a654ca9a938af10d35a652a7a7cb9998f9fa617c2f734a5824485e30f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af44312474aac75419b14a7d940e9c761ff1a6c522781d6ebe3d655a5b1db16d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2f875191722b02fe556ad6362277c52adb322aa71959c68d176ac6eafd9a4e8e"
    sha256 cellar: :any_skip_relocation, sonoma:        "85e64ced77fe37b101eb0801d8426df7db0062c37c8722b3a232c67294d9087f"
    sha256 cellar: :any_skip_relocation, ventura:       "65cf3f0096d0417189d1186bd2e942e3315b57aadd70c82548a65d99f8d5ef45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e843abb75cbaf3f07c5d8bfd54c3959254bea9fd490d3417f2200eb1340013cc"
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