class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "https://radare.org"
  url "https://ghfast.top/https://github.com/radareorg/radare2/archive/refs/tags/6.2.0.tar.gz"
  sha256 "f6d42d722c589d885dd4b55d6b9f1227cab2e837a2e5c1b0523702d1d71875e4"
  license "LGPL-3.0-only"
  head "https://github.com/radareorg/radare2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "49414d078a204b2013fa145bc68f9c636787d67669924bed3b8fa5d8839336e2"
    sha256 arm64_sequoia: "f6a0884db56e0d372526a8dee4255c18a47c2401bbd1fef0764a10902a56bc9a"
    sha256 arm64_sonoma:  "6a78c8252a6c8759347ef220530dc7886dc1c53d9ea1f1a45715b85d9b24b050"
    sha256 sonoma:        "f8928db5ff8724b62b9124148cc0435db2259a48fd1ffac5f1bfc10f6e868f59"
    sha256 arm64_linux:   "08fbc828172879a81f2277d1b18a1534dbd48c99a542407b8c34d3ea8805feb4"
    sha256 x86_64_linux:  "dd5c1206953ea74a8758f706fb7a0e1d317e19d3fc0fc018122f828c720428e2"
  end

  # Required for r2pm (https://github.com/radareorg/radare2-pm/issues/170)
  depends_on "pkgconf"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "radare2 #{version}", shell_output("#{bin}/r2 -v")
  end
end