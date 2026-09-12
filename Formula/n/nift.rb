class Nift < Formula
  desc "Fast dependency-aware website generator"
  homepage "https://nift.dev/"
  url "https://ghfast.top/https://github.com/nift-dev/nift/archive/refs/tags/v4.0.13.tar.gz"
  sha256 "1bb0211fd005376f0cef9a063774e2a90ddc989e789aac06d51d2f9991ee4b26"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ef523cb14b3ef81a3e7cfd2a4da655297310ae2f615560f85dab68b243dbf458"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "da50e6ad7e1a1364764dcd003521065e0dd6a3a4f01bc3cab3084b1200b4c0e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1a57c87a3af167a6505470024b0e1a40192e0681785c90c741b3fabdfba11218"
    sha256 cellar: :any,                 arm64_linux:       "c8d2737f3db74d76d2c97f978189f8903011be2a51c72d7027a3201dd1a110b1"
    sha256 cellar: :any,                 x86_64_linux:      "c0bb5aed6e2021499c6c9d2a83de30d287d986619aff619572dea2533695c709"
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