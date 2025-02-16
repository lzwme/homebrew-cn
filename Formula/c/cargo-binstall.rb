class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https:github.comcargo-binscargo-binstall"
  url "https:github.comcargo-binscargo-binstallarchiverefstagsv1.11.0.tar.gz"
  sha256 "10aa507a14320a257ad07278a7fca4dc1ea5069743d532d17cf8f522cdfd1610"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8cff91831fbe99952b2be878b769837f9f62752521b59826a3a48d84b84c73a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3240e1807fdf419627388fef913cc80fc03b5765161a106cbe977ca943e721cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1abb33fa295403768b1e0cc0332c4a75e6bb057edbea258c8760c6b4ba0ae360"
    sha256 cellar: :any_skip_relocation, sonoma:        "76fa9e2008d9fa1eaa7d29a0d16bf76c6dec5bde81112c6f47209e9ec5c340fa"
    sha256 cellar: :any_skip_relocation, ventura:       "34927420328c1406f415cff8b6915784bfa3ca8ba58ddeea3b30e8751c6f78b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60f7165e7dee3b89c55e0f5377edaabc865c1131b3ca36d33fbfb0d6523c943a"
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