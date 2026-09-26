class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://aube.en.dev"
  url "https://ghfast.top/https://github.com/jdx/aube/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "a5db45fd56ff937afec0b0c503eac4d822c39016cf1e004fba684c50709ee2cf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ccab22ca60d6a7f6991ced728c9c409789fede7f175639a3a059ce70e5b79e8f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1deeb9e8a8c7f24427124e3b614f846f4724e177072a33fc1b967a72497a223d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0e0e11e123c02f8b9061e1b93e4120035daff1a45af259dde554d03b874992e7"
    sha256 cellar: :any,                 arm64_linux:       "ea842747f6438df61dedb571add6e6ac1abf2e53eed5d836302c03612edd1f63"
    sha256 cellar: :any,                 x86_64_linux:      "4889c19f7d4987d76e20686a2d22c04e49a0a02789bb03e165583b273981573b"
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