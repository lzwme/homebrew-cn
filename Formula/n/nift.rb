class Nift < Formula
  desc "Fast dependency-aware website generator"
  homepage "https://nift.dev/"
  url "https://ghfast.top/https://github.com/nift-dev/nift/archive/refs/tags/v4.0.8.tar.gz"
  sha256 "6d5f491beb5d9d61807c4d23f8068c4d024cf927516fd6b51773a9faca6b895b"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7db0bdd0ec317f7c78ccf27bb3200a4113c5ee63ede6404ad071b93e5b4f44d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a72843eced59d421b3b39e13376a8135b8105e9b32c70eee3a78882685db18d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9cc2a03a29062e89ecf77a6f0c7b7150f3780391d036ee45813407ff5069e515"
    sha256 cellar: :any,                 arm64_linux:   "9f1dcbfd6a27b10fdec7281972f98ea995637ce9565eaf794bee558780dcd7dc"
    sha256 cellar: :any,                 x86_64_linux:  "540f8dfd5917c59877da574e77b427ac3cdf99cf923a577dea385c32d096a75b"
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"nift", "init", "--ext=.html"
    assert_path_exists testpath/"public/index.html"
  end
end