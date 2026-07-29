class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://aube.en.dev"
  url "https://ghfast.top/https://github.com/jdx/aube/archive/refs/tags/v1.35.0.tar.gz"
  sha256 "a203a3ce233043ffe73323b9a8cc1ce3fca585eb8a254029790522c9375dea95"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "85cdac1de0a2c5a5f59e2412956befb972e1b3e67af3b151573da7423315aec6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "884dfbeab7b51e3ea3730210b27c5ee8694026f22b95331a990c0114fe0671d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "035fe0d86b066dd4f39f539063597465de42bf23dc38c0f4a27b5fa08e47084a"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce423a7e2c1a41dce9a237f2cca781d08f4cbc3376fb3376c1eff406fdc5750e"
    sha256 cellar: :any,                 arm64_linux:   "ca1aaa9d4c8baec29741c4ada35fc3667b7e9103619c63ac190dc01fdf6ee397"
    sha256 cellar: :any,                 x86_64_linux:  "8295c2be898b1538bff3214c9d8eaf1b10b5ee4d1baceaa2e27d8f6c95fc9335"
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