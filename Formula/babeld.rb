class Babeld < Formula
  desc "Loop-avoiding distance-vector routing protocol"
  homepage "https://www.irif.fr/~jch/software/babel/"
  url "https://www.irif.fr/~jch/software/files/babeld-1.13.tar.gz"
  sha256 "d085ccccfb06a11d7fa5b54c51d9c410f5f3b0a9389f584951336ff178f293b8"
  license "MIT"
  head "https://github.com/jech/babeld.git", branch: "master"

  livecheck do
    url "https://www.irif.fr/~jch/software/files/"
    regex(/href=.*?babeld[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a74bca71e3fcad84ddac8533ea2e859d6bb1967e2ee87b95c6f6f42f5000b2ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6679756ce6d24d8a229428df321b8bbc2d1d1166b3d9283029ce7e3228e3628"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a4a59e08675bf27b83ef104aadcbb6ef6e35ea6783e18bb069a88ee9b7cabe11"
    sha256 cellar: :any_skip_relocation, ventura:        "3df22116dfdd68570929b1a50cd30b4b5ad56299c52ceec08aca2569f87c1b7d"
    sha256 cellar: :any_skip_relocation, monterey:       "68f8e15ff26fbab3d7fbc45282ab295f899eb09e1d2d68d6c24126d83e70087a"
    sha256 cellar: :any_skip_relocation, big_sur:        "c1e162145263761b59ae5b2972a70edb30f0f17f63654383ad83ed799f20b4e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4cfccb10033746d3de7e06a3146b37e6345575b182f25056590733388e6ac034"
  end

  def install
    if OS.mac?
      # LDLIBS='' fixes: ld: library not found for -lrt
      system "make", "LDLIBS=''"
    else
      system "make"
    end
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    shell_output("#{bin}/babeld -I #{testpath}/test.pid -L #{testpath}/test.log", 1)
    assert_match "kernel_setup failed", (testpath/"test.log").read
  end
end