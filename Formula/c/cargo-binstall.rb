class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https:github.comcargo-binscargo-binstall"
  url "https:github.comcargo-binscargo-binstallarchiverefstagsv1.12.4.tar.gz"
  sha256 "f7dde9a0299c38073bc7a8fdb9a200885584ea0a97e1110f439948d11c955077"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "383c23c37d669f05e190056d63f1434fd26f92b5e6223461273e3aa56c845514"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ae41307b02150eb726282b54c8f2c75fab48877d602883fb849de56708909e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "76d84b2a9f8dbc469ad323762e807a68f544c54e88db8fb49f89301e0a76cb99"
    sha256 cellar: :any_skip_relocation, sonoma:        "da678704285a3319fbfccc308f58bab7f7966e9c7c9650e90b8b42e2fd3062c6"
    sha256 cellar: :any_skip_relocation, ventura:       "4fbaab703a634f5ef0269d314447c71581753a3b72d564db2fdbc43f5c70c903"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6f284faeaabdde88e82a96889b87546945459e20e70b569e170f0a017607720"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ebb5f83a3b761633f053fcc22c42113f4634174175c3f9d398d86e10f2678ce"
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