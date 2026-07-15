class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://aube.en.dev"
  url "https://ghfast.top/https://github.com/jdx/aube/archive/refs/tags/v1.27.0.tar.gz"
  sha256 "3e9047840affc2f1957303678410af6d5a89f4a1f361649e97cbd7206d5041f6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e436745e1bb3b01a776124c24ba9f28948b32288fd015d40337df3ad871d79b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbe2585fd3da5d899fb0f3e85dadc7905db5c36a79a25d8b274d8495a5a97e34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "809681009a3610225c1570ea7d51c78f12aeb85a7fd34189359c7b6146c10859"
    sha256 cellar: :any_skip_relocation, sonoma:        "3245a54aa97e7c370136bdb3a7391e32f8e77665ef17f578e22e22232124865f"
    sha256 cellar: :any,                 arm64_linux:   "b70f389955c8eefb2fe1cedfbc64dcb74c88d6f04e36afe9e570f4b58823093c"
    sha256 cellar: :any,                 x86_64_linux:  "f5fcd6732218ff78ea29b5a625592aaf8281d5ba7eee9d5d423756cbf77d05e0"
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