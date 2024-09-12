class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https:github.comcargo-binscargo-binstall"
  url "https:github.comcargo-binscargo-binstallarchiverefstagsv1.10.5.tar.gz"
  sha256 "85f7eb167e4486d53040591b34a48fff256d26e7d69dc34fd82fa8da2a3df9a3"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "4e43d06979b2d3111d65ae89e010ec0e6a992f2abac5b283ca9b8278cf32d521"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6ec3fff0cca195d01716e154b5213d6c0f9f2a1ca6fc2e2b060c7e46704bc180"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b33bd8ffd75718dd096aa67460e6eb4e6398850f5c881e1e602adb59ad5056f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cff6fa7494204eb8e8eb85fa118aaf80840597f6b3adefd38de061735b19e14a"
    sha256 cellar: :any_skip_relocation, sonoma:         "2193672133fc2c9780dfabfcead87e2d9694ba53b8301d3d255b66a85c203b3a"
    sha256 cellar: :any_skip_relocation, ventura:        "adc16eabdced1eadca781927d23bbdddaaed932daa298f007d0a784ffe204c00"
    sha256 cellar: :any_skip_relocation, monterey:       "ca5e8166ad51fc924fbaddce3e5b4ea5b8e72b489645870d24eb2157274362b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c59571f1fa9242a880950d680dc342af25d014a5eeee8a56c25e9945aa3b2673"
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