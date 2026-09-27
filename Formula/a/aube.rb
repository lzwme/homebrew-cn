class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://aube.en.dev"
  url "https://ghfast.top/https://github.com/jdx/aube/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "3b67631408385548cccbe864a7474e001e24afccecf722c2bd7d77fc7bc49d7d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5ae3256ed50f73ab1d5e9eea2316e51552e4dcb3c43db7ac70796aa67c927f97"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c86cdf638f0b70c39c1d01053adce5cca4c935f2ea756c52dd40ec4afac781e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d78f3c8dec80b4f9894a500f02281cb11e04bcc3c73f943963a32227b870ee5d"
    sha256 cellar: :any,                 arm64_linux:       "64ab9bf84143ea772d396772e51935a87107a847cfa7dfe9eb363006c43b5962"
    sha256 cellar: :any,                 x86_64_linux:      "278cfd6f967e7ee1a700bf33f070e6f89fa3fe94c6e7287bb849c70cae741427"
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