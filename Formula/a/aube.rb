class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://aube.en.dev"
  url "https://ghfast.top/https://github.com/jdx/aube/archive/refs/tags/v2.8.4.tar.gz"
  sha256 "6dff091636482b516d2af46bdae989671f36a82304cd69b901236a12c2731d82"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2f200f4ce9acf1fe0ad835e4b1ac4bedef621950c12d58631d8ea99845c2f3b3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1d496f5e0a51d2352b8861876cb2f0d39e924b809ace8237e9deeae586ba7688"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "da306de737de689aa6ba821efef705bafc1eeba1d6d13e8c99e901676c91fd84"
    sha256 cellar: :any,                 arm64_linux:       "be98cc8a85367255f14866f52f232fb1955eabaf6eb18a555b3baa84a5c2a6f0"
    sha256 cellar: :any,                 x86_64_linux:      "4d09441e07d71fa4f7857e7f74cf3a52d5b463fa5f8318ffa2fd6097f685a4e4"
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