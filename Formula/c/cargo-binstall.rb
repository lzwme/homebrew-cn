class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://ghproxy.com/https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.4.6.tar.gz"
  sha256 "0e0da5f351519ddd572b623e51fee772727533684324da7529713778eea2da69"
  license "GPL-3.0-only"
  head "https://github.com/cargo-bins/cargo-binstall.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a20b1d10c10bb62855b5af3de9eec41b34ddb8335134e89f15c739b1e6d6752a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9462e21c7b220ef2d074340a7919bcbde9ac1614dc769313d5de46b79061fefc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4a6e3966f9fbbd4ca48104ecf1ac67e2218ca108e25f6853f9e046d27757d68"
    sha256 cellar: :any_skip_relocation, sonoma:         "1cc3b37c1b0be0bd1421b92798d0df36ddd207172ace1a30a7255a24ea17fb75"
    sha256 cellar: :any_skip_relocation, ventura:        "16a406808aba61b641e60827fbe0de07cb6d51ac971806c5e1cd181d6358a3b5"
    sha256 cellar: :any_skip_relocation, monterey:       "57567b1e39283a4ae02918246aca792771f879cfdd7ac13512357504686092ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77fc7b2af239366db57da893237db144e787d680f9cc4238922932a4ddd5ac11"
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