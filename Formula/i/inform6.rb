class Inform6 < Formula
  desc "Design system for interactive fiction"
  homepage "https://inform-fiction.org/inform6.html"
  url "http://ifarchive.org/if-archive/infocom/compilers/inform6/source/inform-6.41-r9.tar.gz"
  version "6.41-r9"
  sha256 "1f834a977de7d52294b8471b64d768d2197f2117e6a0f6365ad743208ab05be1"
  license "Artistic-2.0"
  head "https://gitlab.com/DavidGriffith/inform6unix.git", branch: "master"

  livecheck do
    url "http://ifarchive.org/if-archive/infocom/compilers/inform6/source/"
    regex(/href=.*?inform[._-]v?(\d+(?:[.-]\d+)+(?:[._-]r\d+)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "66473f965646e839aadc2ab39c71829a165171fb08272b769d5c48f079aae55a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41f4fc0cef4014f1fec5e7cc85721ae8dcff950c6c2da1dc85ea1c1c27f3572e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15058c1ddf4d52cbc108356ab233cfa38182c2929014fa6d853b114302261ecd"
    sha256 cellar: :any_skip_relocation, sonoma:         "b7c404deb4f2bb4cc7fb4efa367f961f7c47ce2d1309c7d9d39cd72c18b35645"
    sha256 cellar: :any_skip_relocation, ventura:        "baf8ad81318ecb25d82077b6babd71f2f22379a973d5f6c3fa377b0bcf86c619"
    sha256 cellar: :any_skip_relocation, monterey:       "3ea7fa8509bc13f0a991c6e97f6d19b46c1122b1c28780490b686a78ad46dce8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "557339f55b5ab462d293fe8b1e3758a37d94e83c2c7da4ffddf75a7971a34e8e"
  end

  resource "homebrew-test_resource" do
    url "https://inform-fiction.org/examples/Adventureland/Adventureland.inf"
    sha256 "3961388ff00b5dfd1ccc1bb0d2a5c01a44af99bdcf763868979fa43ba3393ae7"
  end

  def install
    # Parallel install fails because of: https://gitlab.com/DavidGriffith/inform6unix/-/issues/26
    ENV.deparallelize
    system "make", "PREFIX=#{prefix}", "MAN_PREFIX=#{man}", "MANDIR=#{man1}", "install"
  end

  test do
    resource("homebrew-test_resource").stage do
      system "#{bin}/inform", "Adventureland.inf"
      assert_predicate Pathname.pwd/"Adventureland.z5", :exist?
    end
  end
end