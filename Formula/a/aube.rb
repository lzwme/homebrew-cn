class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://aube.en.dev"
  url "https://ghfast.top/https://github.com/jdx/aube/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "61e8a9be3c252122e77de825b7799a56109044da59143a3251bda8aa4241d1dc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c16f5b7e7d7c59e14a8c6abc8143974e42d04bb6a04e8f881b6677bd992ff974"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bca628387d64d1eeb5717d0fe66cdc7877feac3809226dee55fd6cd9a637c669"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "147bc0b8e2bfc09347056ff34f5152e55a7f9e679beab91836dc2221456ac26d"
    sha256 cellar: :any,                 arm64_linux:       "abdfb1da000c7ed3cc6ee9d28671ff82016f7d2abb0d80431377f9e920def2b1"
    sha256 cellar: :any,                 x86_64_linux:      "e74bf56e0c296c444202ea827722adb9b4789dbe8615cb2b1a121e5c68dab98b"
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