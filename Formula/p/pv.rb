class Pv < Formula
  desc "Monitor data's progress through a pipe"
  homepage "https://www.ivarch.com/programs/pv.shtml"
  url "https://www.ivarch.com/programs/sources/pv-1.8.12.tar.gz"
  sha256 "9687f9deedb09d0dc00d80c30691f0c91282c0d5d8fa7d6a2a085c8742c2cd7c"
  license "Artistic-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?pv[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "49322c69f39d78e80431b3ecbaa984a94b41906809fde4c05f5454af2a5aaef7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d5d03d75411ecec1c57d4d77e51d71cf7c6f6e076b008e281e9e1ff4fa73527"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "047c47b6e7662e5a5e65da526c2942228979a913d19d95d063a30fa3f9828265"
    sha256 cellar: :any_skip_relocation, sonoma:         "dbb3ae11b9e6ec56980c5b11d9b524b68419e841eb6f1c7443e51696cf635c6d"
    sha256 cellar: :any_skip_relocation, ventura:        "241d0aed8541f63dc26bbd9718b6b956184b4a419309923b2e6727ae70a70d0a"
    sha256 cellar: :any_skip_relocation, monterey:       "1f9c9b78b39aa7d94d0dd459634ea43b49b59396e8d26d6b63a2d02fe6a633fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1bf2aa7efad940f801d80ea6eba095dc30db9ef55faaba108d3b0643b864564"
  end

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}", "--disable-nls"
    system "make", "install"
  end

  test do
    progress = pipe_output("#{bin}/pv -ns 4 2>&1 >/dev/null", "beer")
    assert_equal "100", progress.strip

    assert_match version.to_s, shell_output("#{bin}/pv --version")
  end
end