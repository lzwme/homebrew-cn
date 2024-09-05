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
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "d006681611a00c39f5d5c4f6e37cc7c5d42f269a120cc0e4aab1e98253c80f56"
    sha256 cellar: :any,                 arm64_ventura:  "f1307e60c37f3bbe03fdd1d7a413263a8f4d9aa5fc4a29271cace961187646a9"
    sha256 cellar: :any,                 arm64_monterey: "e736ac0ef0f1906473b8d4885e97ccd810b3ce22253575e6f8e12a5f896eab82"
    sha256 cellar: :any,                 sonoma:         "26913bbd09a50a0370e9e8e58822a947d7a84797fdb1f0635bcd2a0d2554c6f7"
    sha256 cellar: :any,                 ventura:        "babd0a9cfdd330e065f413ff4036cd723160e59b5336221ebe5c739282f42615"
    sha256 cellar: :any,                 monterey:       "c2ab9b229382e55d16027889e6fadbd2b697bf1b815781f7eadfdb5d74d97a6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f61fd27993b7ba97457ade6800362c316373707475c01760770f2e99403418c"
  end

  def install
    ENV.append_to_cflags "-fPIC" if OS.linux?
    system "make", "CFLAGS=#{ENV.cflags}"
    system "make", "lib"
    bin.install "svm-scale", "svm-train", "svm-predict"
    include.install "svm.h"

    libsvm_files = buildpath.glob("libsvm.so.*")
    odie "Expected exactly one `libsvm`!" if libsvm_files.count != 1

    libsvm = libsvm_files.first
    libsvm_soversion = libsvm.to_s[(?<=\.)\d+(?:\.\d+)*$]
    lib.install libsvm => shared_library("libsvm", libsvm_soversion)
    lib.install_symlink shared_library("libsvm", libsvm_soversion) => shared_library("libsvm")
  end

  test do
    assert_path_exists libshared_library("libsvm")

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