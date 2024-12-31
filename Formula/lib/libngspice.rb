class Libngspice < Formula
  desc "Spice circuit simulator as shared library"
  homepage "https://ngspice.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ngspice/ng-spice-rework/44/ngspice-44.tar.gz"
  sha256 "8fef0e80b324df1f6ac6c73a9ed9a4120a9a17b62c13e83e1f674a9d9e6a4142"
  license :cannot_represent
  head "https://git.code.sf.net/p/ngspice/ngspice.git", branch: "master"

  livecheck do
    formula "ngspice"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "162528e8b920abfc6a8a3d3192cf18d29e638d369950a4b2b3dda055edff13e5"
    sha256 cellar: :any,                 arm64_sonoma:  "4f722ecb18f76649425033f0d34b67d5a7887c2bb0def3550043c810a7fd4774"
    sha256 cellar: :any,                 arm64_ventura: "af49126c2318f5f85e86eadd45bc13e8e21d389604592c138e3a2936823183ef"
    sha256 cellar: :any,                 sonoma:        "5009ea314d109cb54449c4561661de49ef2fa9f170f50a2a4ba51d34db5445e5"
    sha256 cellar: :any,                 ventura:       "dd2623ded67bc39adfb2375697f2b526f20428e0a57ad252ae94267d1a11d2e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "218acdeadf683ee2a6bb96cf7899b974facfedf90ba7e02db9e5750377423647"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    # upstream bug report on the `configure` script, https://sourceforge.net/p/ngspice/bugs/731/
    system "./autogen.sh"

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