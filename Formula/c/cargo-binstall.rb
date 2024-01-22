class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https:github.comcargo-binscargo-binstall"
  url "https:github.comcargo-binscargo-binstallarchiverefstagsv1.6.1.tar.gz"
  sha256 "eb8c0db03dd410d0ef5417a1cdb9b387e2ee0d3ba8c2e2d1a489a990b865e53f"
  license "GPL-3.0-only"
  head "https:github.comcargo-binscargo-binstall.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ecc06899be02e59cd73b1d5bed88370718fa5c205662a33118f6420a9897f4eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e5f01cd7e72d013a941924061fdabffb87689cda0e1ce033f997bbcc6ccdea6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be7400816994a0e14d0a76b84a5cddf43cec0f4c0cc329ada4371cd04f0b1aef"
    sha256 cellar: :any_skip_relocation, sonoma:         "dcedccad703a3767bf83aec7691c818859b84b48812154b9b7ab126477760cdd"
    sha256 cellar: :any_skip_relocation, ventura:        "240fa14e37643ee7d54313e6719f9d6156a19fa3931c1f06623628e53e246452"
    sha256 cellar: :any_skip_relocation, monterey:       "f21dddf8bb378dd60431a7f37ed5e264a6b97e8ce893c5df2d691ec7002366d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8adf37cfcd227ef0ea86b2dea5a3dbcdff8cde8f4e7fa21f9595764bc46cb0aa"
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