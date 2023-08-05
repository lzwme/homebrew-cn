class Stk < Formula
  desc "Sound Synthesis Toolkit"
  homepage "https://ccrma.stanford.edu/software/stk/"
  url "https://ccrma.stanford.edu/software/stk/release/stk-5.0.0.tar.gz"
  sha256 "0e97d8d2ef0d0d3dd4255fed6d71fcbd832f9977bd1031d2166cdbb865529f11"
  license "MIT"

  livecheck do
    url "https://ccrma.stanford.edu/software/stk/download.html"
    regex(/href=.*?stk[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ecd004639fc1babd09f5631e8f9074baeab1568d485a336f49d2890778ede2f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "859e63bb4cabb78333ca766e9e321fe4c108943ecb018ef75db5c5c1664ffc8b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c7c090f4a05696fe50cfeb30d37c6793de5942158dea2fc7640692bc663cc054"
    sha256 cellar: :any_skip_relocation, ventura:        "a3ae361753bbfee1459c1468a8a6825e564b63fca651baa5577eae3155777114"
    sha256 cellar: :any_skip_relocation, monterey:       "e2f3f5780c7ba303c217ef653052bdd2d3697a0275bcedc8c148432a56f9d09f"
    sha256 cellar: :any_skip_relocation, big_sur:        "0213e3d1451d47c747f099366b48c05eea4e5044fe9019246a25e04317912d46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91f0d49c9668eeb5a4bb98e1e199edb1b028579b7914d61c2555971c2c7ebb4e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    system "./configure", *std_configure_args.reject { |s| s["--disable-dependency-tracking"] }
    system "make"

    lib.install "src/libstk.a"
    bin.install "bin/treesed"

    (include/"stk").install Dir["include/*"]
    doc.install Dir["doc/*"]
    pkgshare.install "src", "projects", "rawwaves"
  end

  def caveats
    <<~EOS
      The header files have been put in a standard search path, it is possible to use an include statement in programs as follows:

        #include "stk/FileLoop.h"
        #include "stk/FileWvOut.h"

      src/ projects/ and rawwaves/ have all been copied to #{opt_pkgshare}
    EOS
  end

  test do
    assert_equal "xx No input files", shell_output("#{bin}/treesed", 1).chomp
  end
end