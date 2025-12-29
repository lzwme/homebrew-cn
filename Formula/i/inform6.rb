class Inform6 < Formula
  desc "Design system for interactive fiction"
  homepage "https://inform-fiction.org/inform6.html"
  url "https://ifarchive.org/if-archive/infocom/compilers/inform6/source/inform-6.43-r1.tar.gz"
  version "6.43-r1"
  sha256 "4dcf3310fb233b3129e8f144a747f5e2a0c17ab72cc43bd3934310502b7c3cd7"
  license "Artistic-2.0"
  head "https://gitlab.com/DavidGriffith/inform6unix.git", branch: "master"

  livecheck do
    url "https://ifarchive.org/indexes/if-archive/infocom/compilers/inform6/source/"
    regex(/href=.*?inform[._-]v?(\d+(?:[.-]\d+)+(?:[._-]r\d+)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c652ef83ef7b3cca51cfcc78f55bcd08a693f625b18bee0fe5a4d1b05a6f567"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92bb2bed0480257ec96c94b8bd67438c3ce85c2513399bbab91ebbcbfc735cc3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6e0751b0eb042c2aed24bd7c1c64a7c3c0d62fbb835b27a54e5c981d22b2877"
    sha256 cellar: :any_skip_relocation, sonoma:        "45bf8c2ef79256a4285b39ef64872415da40a769e3b4188e64e34ce1937c25b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae5c36996b9b15213ef2413164d303e6d59cf6e22fbca5b632ca712a18ab4ad3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd4957f6aa04a0d291be1b20d88c471a41a32e8cb4e9a3712946379925d02203"
  end

  def install
    # Parallel install fails because of: https://gitlab.com/DavidGriffith/inform6unix/-/issues/26
    ENV.deparallelize
    system "make", "PREFIX=#{prefix}", "MAN_PREFIX=#{man}", "MANDIR=#{man1}", "install"
  end

  test do
    resource "homebrew-test_resource" do
      url "https://inform-fiction.org/examples/Adventureland/Adventureland.inf"
      sha256 "3961388ff00b5dfd1ccc1bb0d2a5c01a44af99bdcf763868979fa43ba3393ae7"
    end

    resource("homebrew-test_resource").stage do
      system bin/"inform", "Adventureland.inf"
      assert_path_exists Pathname.pwd/"Adventureland.z5"
    end
  end
end