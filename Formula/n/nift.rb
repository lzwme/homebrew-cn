class Nift < Formula
  desc "Fast dependency-aware website generator"
  homepage "https://nift.dev/"
  url "https://ghfast.top/https://github.com/nift-dev/nift/archive/refs/tags/v4.0.11.tar.gz"
  sha256 "d76d03a8007b01c3046318d1c3f2b1c233fb6a0b50ef55b54af5160aefea1df2"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6875f7382d88187b8ea754d1267618f6f91e7052b0e4b7f2f79941165fb058b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6db0f269bdaa3af423a10b096525fe41abd6d4aab83614670166dc181f5b8ff9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a9796b5d748b5b69f0153c8c328a3570d032c22e08916d383fa4e99eb57db73"
    sha256 cellar: :any,                 arm64_linux:   "6ff1dedcc85043979d13e578237e49ab98c99143a05609d8cdeb5b46b1da318f"
    sha256 cellar: :any,                 x86_64_linux:  "6a9dbac99ce9de9bd6e2392a0268e2dcaa73960f6af10f31d34a9a169590ffc6"
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