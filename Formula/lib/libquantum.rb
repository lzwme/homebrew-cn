class Libquantum < Formula
  desc "C library for the simulation of quantum mechanics"
  homepage "http://www.libquantum.de/"
  url "http://www.libquantum.de/files/libquantum-1.0.0.tar.gz"
  sha256 "b0f1a5ec9768457ac9835bd52c3017d279ac99cc0dffe6ce2adf8ac762997b2c"
  license "GPL-3.0-or-later"
  version_scheme 1

  livecheck do
    url "http://www.libquantum.de/downloads"
    regex(/href=.*?libquantum[._-]v?(\d+\.[02468](?:\.\d+)*)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "1104c2f6a72d4e1576077b6bb549f7e579ccd5d0869ff4e7ea7753655dd5c370"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cbea5e8c46c96ca5adb46cd719b625261e63965deb8884f0fa71814edf2d589e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a4a3d3b7b1525e1105b5fd4212a2b13bdc9e74ae182a4b76b3d5501c4cc8940"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d18cc1cd910ad5b7a0922bb290b9eb79053144d32dcd2071db5658c1e2a4e2fb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5d0d8ffd59105af7232222c76c283dfe0ea6c117eef683669875c9d3d4fb32cb"
    sha256 cellar: :any_skip_relocation, sonoma:         "1d6995bf93a43629913112835f1c5e38e5fdcb9889d5b36eb0f695e3deb44f44"
    sha256 cellar: :any_skip_relocation, ventura:        "ccd0cc6114be77543834fc0c417ab92b155994ba6bcb5183444a38a505fab89e"
    sha256 cellar: :any_skip_relocation, monterey:       "17f91015099d89946404b16a8c3eaab238ca4d9f1806942babdf4a6d1bf940a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "e0c15e357005695499960424b1588ce47b248eb54ba7101cd47d7b0e5427a3b4"
    sha256 cellar: :any_skip_relocation, catalina:       "d4a76e92f03a3ba478985c12c7a4d5fbe815b7b67d8a2d691eadcf43ed5eb1d6"
    sha256 cellar: :any_skip_relocation, mojave:         "437375451fc36404181dd6086f662b0305543fc8765042133706755c804c1217"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "848db672f68b69d8f19e8a80c220aaa182bb762c7bbea799177935fb0208f326"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a528197ff682bb96434f58a4739f933e9010f7e76b368f43d1788fe22468deb"
  end

  def install
    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"qtest.c").write <<~C
      #include <stdio.h>
      #include <stdlib.h>
      #include <time.h>
      #include <quantum.h>

      int main ()
      {
        quantum_reg reg;
        int result;
        srand(time(0));
        reg = quantum_new_qureg(0, 1);
        quantum_hadamard(0, &reg);
        result = quantum_bmeasure(0, &reg);
        printf("The Quantum RNG returned %i!\\n", result);
        return 0;
      }
    C
    args = [
      "-O3",
      "-L#{lib}",
      "-lquantum",
    ]
    args << "-fopenmp" if OS.linux?
    system ENV.cc, "qtest.c", *args, "-o", "qtest"
    system "./qtest"
  end
end