class Libsvm < Formula
  desc "Library for support vector machines"
  homepage "https:www.csie.ntu.edu.tw~cjlinlibsvm"
  url "https:www.csie.ntu.edu.tw~cjlinlibsvmlibsvm-3.34.tar.gz"
  sha256 "2ae0097e623a1dda3a190734f4aead2d9d14914b55bee12a991943894f166a25"
  license "BSD-3-Clause"
  head "https:github.comcjlin1libsvm.git", branch: "master"

  livecheck do
    url :homepage
    regex(The current release \(Version v?(\d+(?:\.\d+)+)[, )]i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "71b7627ea70bd7e431e30fb2e19cd0c4a863391dd8d0d541a74f92517ed557fa"
    sha256 cellar: :any,                 arm64_ventura:  "8b89b82a0759d10c3085ee64de978d84ea6569b6d65bdccb1e37b730acc79e16"
    sha256 cellar: :any,                 arm64_monterey: "8dec9e2d668cf7c53061fe403b11accc3dcae3945b43fbd655962583d502db3c"
    sha256 cellar: :any,                 sonoma:         "d7076dba5fe79d5939c3746a03b04a65c0138ff807af660a874ca971f5f5daa1"
    sha256 cellar: :any,                 ventura:        "e6abda98c5b42ea68babe2cf1c81d7fab983275a64d33807912eb0c2cddb2532"
    sha256 cellar: :any,                 monterey:       "afd9311918cc700e512af3f9cc47b525abf4cad83e922c3d118c888191ed087d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de02f3b1198043abef001c65b452437cff30972ba2b6a893b11501cbe1b26ef8"
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