class Nqp < Formula
  desc "Lightweight Raku-like environment for virtual machines"
  homepage "https:github.comRakunqp"
  url "https:github.comRakunqpreleasesdownload2024.03nqp-2024.03.tar.gz"
  sha256 "5f642ee1a4597b758a6d1170464cc0a27f1216b21624790bf053f1c86bbfe0b1"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sonoma:   "aff0e78bac9ffd51838c2a872c802ae0330e9339e76d22dad895e5b0207a9b70"
    sha256 arm64_ventura:  "04593a51f94cd0179f7ee539287dd9fc5c2b393c224d359a058f0beae2d84890"
    sha256 arm64_monterey: "21f49eab62f6dadb81572e72238ca3b3ef894e6d4afe72d563d6d5406c765872"
    sha256 sonoma:         "197ccdf7c151ae157c6a9acb0382f313868eb2468c59905b296cb3f900a4922a"
    sha256 ventura:        "0797f9759c4e43aa402d9e176f48ee03c49949e9ad1bf4f39ba2162b9e555554"
    sha256 monterey:       "41666ea765b081aebced4d6097df42c19f1b04388a904c1cf5ee3d519c35a67b"
    sha256 x86_64_linux:   "1ddd2af4609ff5ed68b7c0b0e6fd9fe764148b1bb3d0868da4879e6d0131ac21"
  end

  depends_on "libtommath"
  depends_on "libuv"
  depends_on "moarvm"

  uses_from_macos "perl" => :build
  uses_from_macos "libffi"

  conflicts_with "rakudo-star", because: "rakudo-star currently ships with nqp included"

  def install
    ENV.deparallelize

    # Work around Homebrew's directory structure and help find moarvm libraries
    inreplace "toolsbuildgen-version.pl", "$libdir, 'MAST'", "'#{Formula["moarvm"].opt_share}nqplibMAST'"

    system "perl", "Configure.pl",
                   "--backends=moar",
                   "--prefix=#{prefix}",
                   "--with-moar=#{Formula["moarvm"].bin}moar"
    system "make"
    system "make", "install"
  end

  test do
    out = shell_output("#{bin}nqp -e 'for (0,1,2,3,4,5,6,7,8,9) { print($_) }'")
    assert_equal "0123456789", out
  end
end