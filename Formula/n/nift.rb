class Nift < Formula
  desc "Fast dependency-aware website generator"
  homepage "https://nift.dev/"
  url "https://ghfast.top/https://github.com/nift-dev/nift/archive/refs/tags/v4.0.4.tar.gz"
  sha256 "7e3772be753e94cac1e6845573ccfb5b93c8232c62c45abed960e36e3d14319e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "43bb5ce6e5b1b09d08dd992f5bdf78363d349fd46754dd6f6fa4c88a815d7485"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9cc60035cfd398a55b6c7e4779b47704afcde18040a35a7a58b5ec1fa2746cf9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3cf08965c0467da3eaf4543de91029364a090aa7b9234609b70686dadbae0970"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a9d0a29b61780b0066e64ef3b070bbf97ecf2380364e71d0cd62d8379728706"
    sha256 cellar: :any,                 arm64_linux:   "d8e67da5f9ca08bf8926532df0a23e25b3e69cea333fcbafa1b068192159c194"
    sha256 cellar: :any,                 x86_64_linux:  "bdffa40977eddf12fd08e9fc595ff1f1600b44bff443321df68fe3bad21daa3f"
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