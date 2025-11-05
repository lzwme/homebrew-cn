class UserspaceRcu < Formula
  desc "Library for userspace RCU (read-copy-update)"
  homepage "https://liburcu.org"
  url "https://lttng.org/files/urcu/userspace-rcu-0.15.4.tar.bz2"
  sha256 "11a14a7660ac9ba9c0bbd3b2d81718523d27dc6c8a9dfabd5e401b406673ee3a"
  license all_of: ["LGPL-2.1-or-later", "MIT"]

  livecheck do
    url "https://lttng.org/files/urcu/"
    regex(/href=.*?userspace-rcu[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "73e24f9bd2c348544a56c7167b06afa25deeff1d06d7ccbf8fc8a4d05d92cd69"
    sha256 cellar: :any,                 arm64_sequoia: "3d71fa066be65b7a15f75e8879ab4e00f1ce8d2e582737dde0517f51699a3a17"
    sha256 cellar: :any,                 arm64_sonoma:  "d0b90ec6a2e738188e30835e931e1524ef0e6a931988fe8f0dfeb2cf3190302a"
    sha256 cellar: :any,                 sonoma:        "db073e0a6b364ecbd2e2c45cc7c2c0910996179e60df480cb0f004d0842805da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2e3f1a5830fb928803e65a234d7ea600992786618cce7f7324ceabeb0757ab3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a827421a2bf2f55fe8c4c3c4e15209a1c7ed7dadbde7a4e47305731274129c8"
  end

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args.reject { |s| s["disable-debug"] }
    system "make", "install"
  end

  test do
    cp_r doc/"examples", testpath
    system "make", "CFLAGS=-pthread", "-C", "examples"
  end
end