class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://ghproxy.com/https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.4.5.tar.gz"
  sha256 "82db29d3e990fefcbeab9447da1b13e4e62b31aceeff38b8860510f9acdd357b"
  license "GPL-3.0-only"
  head "https://github.com/cargo-bins/cargo-binstall.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "829a51b907a84599b190850a8b815386d2cd791aa6f1cd198fb9ee867dcc2de0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "69db8b9ed808815899f2fc6f2ca5e7a56e74768df9033d498198bab4741db36f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f041766151e0d5992e1bde3c71063e377639a3fcf9de544cb9daa31371cb3fa9"
    sha256 cellar: :any_skip_relocation, sonoma:         "82a7df6d9bc77a9e7cdca90eb156fb62b13761e9924c252521643d49757c2504"
    sha256 cellar: :any_skip_relocation, ventura:        "5ac87f045920afc8484ec97694985ac0b63d580efc1293d52ee0d5bb704ac53f"
    sha256 cellar: :any_skip_relocation, monterey:       "ecf050f05c21bfd39b19c8613ffbcd2ee914f0eeb9639351ae17e0b684f30746"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ffd757a4397730aedb9dcbf6295d4f3d19bd54e4050ff4532063213b36c39c3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/bin")
  end

  test do
    output = shell_output("#{bin}/cargo-binstall --dry-run radio-sx128x")
    assert_match "resolve: Resolving package: 'radio-sx128x'", output

    assert_equal version.to_s, shell_output("#{bin}/cargo-binstall -V").chomp
  end
end