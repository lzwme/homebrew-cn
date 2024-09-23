class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https:github.comcargo-binscargo-binstall"
  url "https:github.comcargo-binscargo-binstallarchiverefstagsv1.10.6.tar.gz"
  sha256 "4b83cb733990a310e137a4f78b8dbcf9efbb6a59c25fd0c9312bd8ad2f55df87"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "346663d3a60244ab69c38c3b559fd29b16bcf60678ff04c7e842e880aa7b728d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5901bb7bd3ca576246abad905b293e282764678e968ec42a4f22e50f72cab37"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "75b3fa670eb2ea2cbe14505a4fd58cf3d13e8c3bc0327615bea03df1a893d797"
    sha256 cellar: :any_skip_relocation, sonoma:        "91d94277fef2eabb16509b73447d2cfd7fdb6155430e6884ee1a9296d2f41234"
    sha256 cellar: :any_skip_relocation, ventura:       "2b5075f1e67c1cf1d7fe023573e919ba0a271b1c72b63ab69a52a3851201e1f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1212d8099a790a9d25d5da2bd5f1f3ccaa1bab785f11170faee83ed5bd2abb3a"
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