class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://aube.en.dev"
  url "https://ghfast.top/https://github.com/jdx/aube/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "fbe4cc7097b0374ee73fa1fa32f229a8a8ba48e6b9792661857e9499a1e20e1d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e98bcc1de17ea06abf9ca0854320bfc14313de9f2e16fc59563446ad40e864f2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2696e89a1f6659ab938c9ba5f062eb2df87bae10cd30636a8c6b4f9f834aaf01"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cb66d917ca00a5127cc6c9d451a18e0afe42aa573ddc7901552c405fd0bee707"
    sha256 cellar: :any,                 arm64_linux:       "558baa49952f09cdd9102bc28b601245c44110a73d5dd14e090d55f410791ab3"
    sha256 cellar: :any,                 x86_64_linux:      "7c5f821955fbe9a1511b09ad8748fbd2f7b175251ae0ad4e27fecc0b2e13c302"
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