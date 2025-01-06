class Libngspice < Formula
  desc "Spice circuit simulator as shared library"
  homepage "https://ngspice.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ngspice/ng-spice-rework/44/ngspice-44.tar.gz"
  sha256 "3865d13ab44f1f01f68c7ac0e0716984e45dce5a86d126603c26d8df30161e9b"
  license :cannot_represent

  livecheck do
    formula "ngspice"
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "5ca4aafb0d8d00dbec59105f6e9394ad41cac1d336bfa99d6df6f498e092b46d"
    sha256 cellar: :any,                 arm64_sonoma:  "1dbae25eadece6a55ef3587f036e57637b5445584e01c7f81207d561a0c61157"
    sha256 cellar: :any,                 arm64_ventura: "976c56210d4d2b8c696a6459655aca268c76c95046823c56b918ac8f2d67e752"
    sha256 cellar: :any,                 sonoma:        "84ce8f9c8baad54f2fd1fde08a05377ee63105197676e81a3806fccfa4a3a483"
    sha256 cellar: :any,                 ventura:       "a9d65308d6198d261cc580c5fccef2e3db31e1809f2b244c9e9ab71b6761f787"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5130aeefd3dfecc8dc59bda538e1b11da9c6b6540b225fa5d3ee00fc71db7b09"
  end

  head do
    url "https://git.code.sf.net/p/ngspice/ngspice.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    args = %w[
      --with-ngshared
      --enable-cider
      --disable-openmp
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"

    # remove script files
    rm_r(Dir[share/"ngspice/scripts"])
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <cstdlib>
      #include <ngspice/sharedspice.h>
      int ng_exit(int status, bool immediate, bool quitexit, int ident, void *userdata) {
        return status;
      }
      int main() {
        return ngSpice_Init(NULL, NULL, ng_exit, NULL, NULL, NULL, NULL);
      }
    CPP
    system ENV.cc, "test.cpp", "-I#{include}", "-L#{lib}", "-lngspice", "-o", "test"
    system "./test"
  end
end