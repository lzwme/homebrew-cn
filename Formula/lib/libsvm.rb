class Libsvm < Formula
  desc "Library for support vector machines"
  homepage "https:www.csie.ntu.edu.tw~cjlinlibsvm"
  url "https:www.csie.ntu.edu.tw~cjlinlibsvmlibsvm-3.35.tar.gz"
  sha256 "ea5633fc84b1c2fa58aa4c44b62e437573020297a1dfbe73bf1531ec817a8478"
  license "BSD-3-Clause"
  head "https:github.comcjlin1libsvm.git", branch: "master"

  livecheck do
    url :homepage
    regex(The current release \(Version v?(\d+(?:\.\d+)+)[, )]i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "de3581dfe3a5f5dfbbe1a90a0a6a049c560edb28383cc7add9c0cd8c5426571d"
    sha256 cellar: :any,                 arm64_ventura:  "d124df71f8e3b61e3be22146f40381208a816e798662d00069c4623caa868d11"
    sha256 cellar: :any,                 arm64_monterey: "b87dcf21aa430e9e658db5b55566a096ce9c63e3838cf35dabb0572ece956c3a"
    sha256 cellar: :any,                 sonoma:         "509e728caeda57af8a785298597e3cfff74beeb83b29bece27639a932cd62046"
    sha256 cellar: :any,                 ventura:        "6accd6a1308997ee925774b15c7e14b76724efa09ec9c0d8ec0103394f8fd339"
    sha256 cellar: :any,                 monterey:       "8fc8d377c9b34d581bb3f4a0260ab3824a6c010fa399452e7dc32bb5c0174bef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b53f35dddb34467e73c49f616c72dfa3305fba1728b8f65cce41d361a83a92ba"
  end

  def install
    ENV.append_to_cflags "-fPIC" if OS.linux?
    system "make", "CFLAGS=#{ENV.cflags}"
    system "make", "lib"
    bin.install "svm-scale", "svm-train", "svm-predict"
    lib.install "libsvm.so.4" => shared_library("libsvm", 4)
    lib.install_symlink shared_library("libsvm", 3) => shared_library("libsvm")
    MachO::Tools.change_dylib_id("#{lib}libsvm.4.dylib", "#{lib}libsvm.4.dylib") if OS.mac?
    include.install "svm.h"
  end

  test do
    (testpath"train_classification.txt").write <<~EOS
      +1 201:1.2 3148:1.8 3983:1 4882:1
      -1 874:0.3 3652:1.1 3963:1 6179:1
      +1 1168:1.2 3318:1.2 3938:1.8 4481:1
      +1 350:1 3082:1.5 3965:1 6122:0.2
      -1 99:1 3057:1 3957:1 5838:0.3
    EOS

    (testpath"train_regression.txt").write <<~EOS
      0.23 201:1.2 3148:1.8 3983:1 4882:1
      0.33 874:0.3 3652:1.1 3963:1 6179:1
      -0.12 1168:1.2 3318:1.2 3938:1.8 4481:1
    EOS

    system bin"svm-train", "-s", "0", "train_classification.txt"
    system bin"svm-train", "-s", "3", "train_regression.txt"
  end
end