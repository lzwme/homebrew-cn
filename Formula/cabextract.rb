class Cabextract < Formula
  desc "Extract files from Microsoft cabinet files"
  homepage "https://www.cabextract.org.uk/"
  url "https://www.cabextract.org.uk/cabextract-1.11.tar.gz"
  sha256 "b5546db1155e4c718ff3d4b278573604f30dd64c3c5bfd4657cd089b823a3ac6"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?cabextract[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e4cd53d32db9ea97656f399dd9033eaa5ef5c8cc3226de8de09865e6c610435"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "371a13fefca5fbd78edd570020e5f0eaf82536c55e54a8efd01fe7570103cd01"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3d71ed3ba74cc371c392104c0f9c8f2fdc8e504e046140f5c1c74e95680fd6db"
    sha256 cellar: :any_skip_relocation, ventura:        "2e30506702df76799a4c685f6004e58cbf06b27a1bbb25fb401f802aa95bd80b"
    sha256 cellar: :any_skip_relocation, monterey:       "add98c9cb4c6d920c8acb6378ad9bec3bf1f95f531a522c07e4cfc6bf00c687f"
    sha256 cellar: :any_skip_relocation, big_sur:        "af25a0c0dadcae5b550953a5c2857533c65013ff65daaa67555d6bf0b204249c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5631eaa72da365accb3b576606fcfcc619879e83bfdd97c74233c073f6f42374"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # probably the smallest valid .cab file
    cab = <<~EOS.gsub(/\s+/, "")
      4d5343460000000046000000000000002c000000000000000301010001000000d20400003
      e00000001000000000000000000000000003246899d200061000000000000000000
    EOS
    (testpath/"test.cab").binwrite [cab].pack("H*")

    system "#{bin}/cabextract", "test.cab"
    assert_predicate testpath/"a", :exist?
  end
end