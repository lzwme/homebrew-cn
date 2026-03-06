class Termframe < Formula
  desc "Terminal output SVG screenshot tool"
  homepage "https://github.com/pamburus/termframe"
  url "https://ghfast.top/https://github.com/pamburus/termframe/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "a3539aa9df7ccc803e32cc70b6fd93c791dc1b8e3e20c369705730d3a103c9a4"
  license "MIT"
  head "https://github.com/pamburus/termframe.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "76309dc3d7d6bbb15f4fa4986564b0714f206c69d3fe8f35c6ae9de332e62da4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71428fe3c27c633e976e5381e7c783f4f8b105caeae7b6323a2f08701443b771"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57f1abb59a952a93b549a95123eaf075da13ce5d3df73a78fcc3afdfb2f5a4cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "046dbca969dd0d61a82c350a2f63ead170903e022363f95c2cbb4e060c1ed31a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "391d4d491c9a12f92c0b210148f9982c7da9eeea55420a14b8107cc2c1c5973b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f174bc5f25f04552874aed43b491167dfb70831394853b4d5a9a72e33481e437"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"termframe", "-o", "hello.svg", "--", "echo", "Hello, World"
    assert_path_exists testpath/"hello.svg"
  end
end