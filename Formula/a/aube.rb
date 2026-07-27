class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://aube.en.dev"
  url "https://ghfast.top/https://github.com/jdx/aube/archive/refs/tags/v1.34.0.tar.gz"
  sha256 "22c4581c4a84a8895388e81a81f31d16dcb86913990106a9591c9fec69fdf7f1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9166bdf2bcb0990f08570b7c6b6fb29c8d79106c95ec8d4ff6e0a09be570d900"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28e29faba04d0a773dad09b82c45c5156a0e2a947bbee3810dbe2f05b90ce85e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5fa32448bb974fe982749a1d9d330c832630402d06c71f767fab99be671f970c"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7d2736324a6cd348aea370da9c622fc9aea56c0280cb802f844f5b951f4ae84"
    sha256 cellar: :any,                 arm64_linux:   "d5051ddd65f8302e5f34e9ccd80ec910b7e1fbe3e59ba444194b1993db54b5a4"
    sha256 cellar: :any,                 x86_64_linux:  "7a6f0935f47864c4b778c4d9667052a300e1e3d25bfcc303d99ac9e08e861dd9"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "usage" => :build
  depends_on "node" => :test

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/aube")
    generate_completions_from_executable(bin/"aube", "completion")
  end

  test do
    system bin/"aube", "init", "--bare"
    system bin/"aube", "add", "cowsay"
    assert_path_exists testpath/"node_modules/cowsay"
    assert_match "< moo >", shell_output("#{bin}/aubx cowsay moo")
  end
end