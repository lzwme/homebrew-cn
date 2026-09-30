class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://aube.en.dev"
  url "https://ghfast.top/https://github.com/jdx/aube/archive/refs/tags/v2.6.1.tar.gz"
  sha256 "69fe32b2a6cfc61828dc07fd4bd888eb58b2a6803a5d9e95fba5c511bdc3c8fc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7ade0544f5f407b4eb51239d27aba4b7de626c9d0834f996973e904daa909a5e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "16e8f547f3663acbf3dc50a4d3a46de0c72f2983913a586a056f8fb2664b0f3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4644d030c1954595457242a1cc1f723b27938bed8237bd80ba35184e6b7f4eac"
    sha256 cellar: :any,                 arm64_linux:       "97a7374ec54f428364dd2338304c4366e3ea4de2eac48aa1cf1038330080af2d"
    sha256 cellar: :any,                 x86_64_linux:      "f50823afc3562585b21cd76bfb5d029a6d397bca56c5c189928051f9e96c3d3e"
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