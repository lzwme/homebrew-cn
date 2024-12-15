class Lbdb < Formula
  desc "Little brother's database for the mutt mail reader"
  homepage "https://www.spinnaker.de/lbdb/"
  url "https://www.spinnaker.de/lbdb/download/lbdb-0.55.tar.gz"
  sha256 "f642cf835dc13291bbd066f67186d485c8f4d318f3cf5228febba6b1a108392a"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.spinnaker.de/lbdb/download/"
    regex(/href=.*?lbdb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1774ad2e2d7ede97cd22d0c9a4615a7a1116e08c629bdca5078d53dfae403d76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b975153af7f2519b2ec424c89e78fc33b035a1c605d24bea231018c3b76bff79"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5568cf6cacd053412e7fd19401c0c825918af89020d0baddc97f7bcc55e91445"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c2db788d93aa372bd0073680e00e0fe444f262e18795ae8d11bb7656de7630a"
    sha256 cellar: :any_skip_relocation, ventura:       "a4941dd0321535accfcf96fe45c1d793da06a762ae09833fe7dace524955389e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8da04acbb6abea80a391a408df40c690853a957c01618e7aff0f374df352f2a4"
  end

  depends_on "abook"
  depends_on "khard"

  def install
    system "./configure", "--prefix=#{prefix}", "--libdir=#{lib}/lbdb"
    system "make", "install"
  end

  test do
    assert_match version.major_minor.to_s, shell_output("#{bin}/lbdbq -v")
    assert_predicate lib/"lbdb/m_abook", :exist?, "m_abook module is missing!"
    assert_predicate lib/"lbdb/m_khard", :exist?, "m_khard module is missing!"
  end
end