class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https:github.comcargo-binscargo-binstall"
  url "https:github.comcargo-binscargo-binstallarchiverefstagsv1.14.0.tar.gz"
  sha256 "0bf1a100cdbce8fc80bd524ad305c698143a81135ab62570918ac997a1ae21e9"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "750c1b9f287fbdce9054cb8fd9b1d9f5d18a94a78abc364af885082c861b0c84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f42dca0ab273e03f1fe0882a3e88899c95ae1854edf73c718198208c02982b9a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3389655928f5f496f5df20df026dd9b08b3ac99360de0ccb76de73aca1ef85f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2239f04ea9171f60f11d18d64eccf96c7662272f25fe1a8dd13aecefd590a42"
    sha256 cellar: :any_skip_relocation, ventura:       "f8bfd995895758003ceb6cbbe8b364f9fc01659ef47752ebf027813e3e2c63df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "551e14cd052f0fdf9bd5eb89a829d49eab436e9c65a18b8002cb7e22b7195ad7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bab9b22b9f4f9ac05a5087d426124669897cdd42839728eae49f94d28223f90f"
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