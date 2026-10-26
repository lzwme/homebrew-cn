class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://aube.en.dev"
  url "https://ghfast.top/https://github.com/jdx/aube/archive/refs/tags/v2.8.3.tar.gz"
  sha256 "fe8a03efa3c72a9d96d49cbe6bc17b7e858074277f541c93562af55d1af5ed75"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "08051b3bbec86b25cb25a49757abfbb669d257cc303c7c731e14a5454832dd0c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "89f0d0baae793ba112f1603b267d1424ded2f16aa0010dd4ca3f8ec9476718bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a63075b78a569a71bfc59d7e1c980e7cff370c3ad8828dda6fa735a22a7c01f7"
    sha256 cellar: :any,                 arm64_linux:       "6fb5f1b8d39f899559aa095e55a755d3fa4f12ca0e5ff59057f55ff63ebda781"
    sha256 cellar: :any,                 x86_64_linux:      "a30b9e4efd7c80269f6b882c520af469a0fe0b51c2744da46280ca44866aba0b"
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