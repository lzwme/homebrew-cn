class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https:github.comcargo-binscargo-binstall"
  url "https:github.comcargo-binscargo-binstallarchiverefstagsv1.11.1.tar.gz"
  sha256 "0a3a0bc86f64804365093bf25a91cfbbe26c8f5c190379ef10b01609562c126b"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7f2b564d22bbe2c7f13ea8a482f57c14b3e438de99ec778ad00b4f7641c75ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e09f9d768abb750037b6c8998dfeca3e27960cd06185f047a7e1307a0d474f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a67d3827238b4fd4997952285a443f7bce2b04edfa157d8c7c30f520caa2ef42"
    sha256 cellar: :any_skip_relocation, sonoma:        "fda972b1888a73bc0e65ab55a591c57351e713c0bf3aa124e04ecc19d1f0159d"
    sha256 cellar: :any_skip_relocation, ventura:       "2c6bd442009733c7430322ba9829cb47ca907b0119a36a423cd35dd641ef4829"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01435219a7e118f820a92b51e8b3492b0dd630f5a9a72bb234bfdb72b8b53831"
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