class Libnatpmp < Formula
  desc "NAT port mapping protocol library"
  homepage "http:miniupnp.free.frlibnatpmp.html"
  url "http:miniupnp.free.frfilesdownload.php?file=libnatpmp-20230423.tar.gz"
  sha256 "0684ed2c8406437e7519a1bd20ea83780db871b3a3a5d752311ba3e889dbfc70"
  license "BSD-3-Clause"

  livecheck do
    url "http:miniupnp.free.frfiles"
    regex(href=.*?libnatpmp[._-]v?(\d{6,8})\.ti)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "5bda7f405b5e81802f57ff903108f1f6a55a3fce5109b3f158c812680ae13551"
    sha256 cellar: :any,                 arm64_ventura:  "e2b3149c35d8f3b95be8530a59185bff9d795599b7311d8cbb5acdd815737b83"
    sha256 cellar: :any,                 arm64_monterey: "f859a0235c76bb63c350d94f053832a15fee55936a8e7a03a5b5dc04dd69c627"
    sha256 cellar: :any,                 arm64_big_sur:  "0e39353eba562756a31d3937f87c68f5d6b66526bfabb3cb5db71b5c7cce1bd9"
    sha256 cellar: :any,                 sonoma:         "e79bae12df6cbd0880010d1ece79b94c7f8a0d17173bc2307b5a12bcf6007cd4"
    sha256 cellar: :any,                 ventura:        "2997902f048650bd589d999bb508836f9275432f702041922d63577f526ae427"
    sha256 cellar: :any,                 monterey:       "8d9857a3229541160545cd65308faede6b0a4a49b22491fa2726b9b391797dd1"
    sha256 cellar: :any,                 big_sur:        "b3e8cff2d63434c2f2db23be4caf16799c420f9ef7308dca1173b5cf3ff6b9b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c61e68ce733b200615ecb9dbabe36a9336cf7d6404a4d869573a365acaebc08"
  end

  # Fix missing header. Remove when no longer applicable.
  patch do
    url "https:github.comminiupnplibnatpmpcommit5f4a7c65837a56e62c133db33c28cd1ea71db662.patch?full_index=1"
    sha256 "4643048d7e24f8aed4e11e572f3e22f79eae97bb289ae1bbf103b84e8e32f61a"
  end

  def install
    # Reported upstream:
    # https:miniupnp.tuxfamily.orgforumviewtopic.php?t=978
    inreplace "Makefile", "-Wl,-install_name,$(SONAME)", "-Wl,-install_name,$(INSTALLDIRLIB)$(SONAME)"
    system "make", "INSTALLPREFIX=#{prefix}", "install"
  end

  test do
    # Use a non-existent gateway.
    output = shell_output("#{bin}natpmpc -g 0.0.0.0 2>&1", 1)
    [
      "initnatpmp() returned 0 (SUCCESS)",
      "sendpublicaddressrequest returned 2 (SUCCESS)",
      "readnatpmpresponseorretry() failed : the gateway does not support nat-pmp",
    ].each do |expected_match|
      assert_match expected_match, output
    end
  end
end