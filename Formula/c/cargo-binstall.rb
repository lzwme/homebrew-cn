class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https:github.comcargo-binscargo-binstall"
  url "https:github.comcargo-binscargo-binstallarchiverefstagsv1.10.18.tar.gz"
  sha256 "6b99a50a923a502d61d3d023c19273329a4f409827416c3c8c35c367034b3ecf"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3bed82932b97b0c4187fde5405039e0076882115f9b12553e4e7a599e338e69d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9480143995d4f367049b2b4559d2c9f1dbcf82dae5646d437edcd79fa0e36822"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "202c2cfa1a78a316b3add3f758b38be32615a1fc1ced0e24ab3d0194bb6bbffc"
    sha256 cellar: :any_skip_relocation, sonoma:        "de30c08a7fbebd17ef4fa068d851129c90e885bc8aad0aed9cad121e1037a862"
    sha256 cellar: :any_skip_relocation, ventura:       "de775b4ccfe389548f5137f20e635390b566f67b9062fee47d5a5b02533efea9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb2e5f1b284cc6d221703b8043677de940109a70b433f4fbd5b3f90838f665f2"
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