class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://aube.en.dev"
  url "https://ghfast.top/https://github.com/jdx/aube/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "21e848a45b3ed2087533e0fd86cf6f94a2ae6cae027526af57a4525f2d3ce497"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e421f92c77e91422c304ec53a21f3fa4ece13005df5d53cdc123b0dc9ebe6b31"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "38c0e83f7bba003d7edf4b7c1c80ed0b9d507f851fd5f4f4c68bd64cd6d31ed3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "abececdaa441488731095f65174a0629429bd66d4921dbd1ef3d8892ac9db798"
    sha256 cellar: :any,                 arm64_linux:       "66fd9883c17321d22d7eb0de9ea8254a6c419b721b415c2bcb0c6f65109a4e19"
    sha256 cellar: :any,                 x86_64_linux:      "b8a8eee1037e4a255f9e505db797c30173438a4415d00353245cfba2b43beca4"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "usage" => :build
  depends_on "node" => :test

  # Test installs a package from the npm registry
  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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