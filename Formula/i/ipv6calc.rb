class Ipv6calc < Formula
  desc "Small utility for manipulating IPv6 addresses"
  homepage "https://www.deepspace6.net/projects/ipv6calc.html"
  url "https://ghfast.top/https://github.com/pbiering/ipv6calc/archive/refs/tags/4.3.3.tar.gz"
  sha256 "9e2a9aa3d7cd86f74793d5ebf383f2fa933cbc8f26c3917394f6b995ae92612d"
  license "GPL-2.0-only"

  # Upstream creates stable version tags (e.g., `v1.2.3`) before a release but
  # the version isn't considered to be released until a corresponding release
  # is created on GitHub, so it's necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3fc67a7ecfb7805480a9d4af97866763851b570742a4d19ca92bac2bbebb2da5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6172c77994817e23b21d59eb23311d15aef4518601a8936a82900fc0c2a9c416"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "290e5142336d042aea62f38e735fdfbb64e7f2dbe49f68690e7684be83f67fd2"
    sha256 cellar: :any_skip_relocation, sonoma:        "341eb60b6ed540067848488870d5dde402eb73753b54461ecc9ae2d7fa48c9b8"
    sha256 cellar: :any_skip_relocation, ventura:       "ad7ffd0ad2500e2ff120a98f9ba021e87c7f222f65dc9bd8e449b662b1725239"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c21dc5cd0627fc7fdcb032f07058fc114d25b3572ed31a1987fc8e50c38877ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a3853e8b712761dcafa1e2e8094b0148220d7fc24b895a3ee321e4a4e5aff7c"
  end

  uses_from_macos "perl"

  def install
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "192.168.251.97",
      shell_output("#{bin}/ipv6calc -q --action conv6to4 --in ipv6 2002:c0a8:fb61::1 --out ipv4").strip
  end
end