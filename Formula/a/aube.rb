class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://aube.en.dev"
  url "https://ghfast.top/https://github.com/jdx/aube/archive/refs/tags/v2.2.12.tar.gz"
  sha256 "598b6dd1de288f6f9e5ece4a5efdd023a50858aeac307142a877e28830b269ec"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc0a0930460f42ab8c209d896e44961e49fa5623dc90d6c4a8b145db34efdb04"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "627d572ac546b805584be799b5846b2372c77a162edeb3f98647e93df6b9e8e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a36b32a6f1218f70f2ff6fb2321ccc1b2ab46bfd4f713f30d378c2c26d952d54"
    sha256 cellar: :any,                 arm64_linux:   "ba903816802ecce5cbf12296a1db5616fb66515160b0b84b44ad324f5b7ab45a"
    sha256 cellar: :any,                 x86_64_linux:  "b7807557ee503a3c7b730eac3b6bc6c6d1aa85d7b7e0d1e5bbf556e1989d58f4"
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