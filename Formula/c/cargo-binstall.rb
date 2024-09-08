class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https:github.comcargo-binscargo-binstall"
  url "https:github.comcargo-binscargo-binstallarchiverefstagsv1.10.4.tar.gz"
  sha256 "6da5703b8447324e2e5b6d83597f9aaadaf03fde9a365fa5cc6f3590f7ff9d0b"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "49cc6aafc7866d195816a296f3e322272fd3ecefbf3559d8925cee3f5e71f948"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3b7dd34f312ee3d605055eef365bec9e6d0b02d06f8d29b809e3f90f74afe23"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d9a4b940098a116886c137c114786aa1e96b6ae1bad5765202a20612b9328b7"
    sha256 cellar: :any_skip_relocation, sonoma:         "b59526862aea72e46deb3d6acd06dbdc18dea4fea456fc1cb99980f2c307b19c"
    sha256 cellar: :any_skip_relocation, ventura:        "5445a9f50d30764f68f16c2d3a8a847a8c76d5d8bc4cb912d8e2fbe426f8827f"
    sha256 cellar: :any_skip_relocation, monterey:       "7d86f8f2bd1267d193c3cbfffdf1208e77eca28bc9fa3787badcfd896ef710a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b695ef9cb96be5c7482e46a37eb50f59ea7d2ca35134b5bdd0bf9c981fb9c28"
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