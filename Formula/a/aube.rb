class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://aube.en.dev"
  url "https://ghfast.top/https://github.com/jdx/aube/archive/refs/tags/v2.2.3.tar.gz"
  sha256 "2a09ebe265671327b1487854b7d30b3631babc96fa3d2aecc3fad66264b094fd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "24b835a5ca21b72dc97bfd39488d4e0b11e5157810ea79b324363762debb8f24"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56b8fda86a1444ebf3ac7277988c24fa4509ee4b3b7ccb75843f3412cd9ff264"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "885bde53469f682f5b0de16583753ed173e10fd54b17813d5975251c2d27e01e"
    sha256 cellar: :any,                 arm64_linux:   "d3c348c4989815a01189fa7c83284b28cec2c94196344b8190d9c176063c0385"
    sha256 cellar: :any,                 x86_64_linux:  "1fbaf79e8828427c8f2a69fd0ab288ccea6aeaad0d37017b7bfa0aa71e96e660"
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