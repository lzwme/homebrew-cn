class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://aube.en.dev"
  url "https://ghfast.top/https://github.com/jdx/aube/archive/refs/tags/v2.2.16.tar.gz"
  sha256 "5aa68b7d783b1e14ce0ec358217ca6c4ce81cd2240221079bdad942d368ac3a2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9ca331c5938dd0bfeba01aed1549c42c86862797a8508272669c5bb2dcab0af2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "590c3a7a6707b9d369ee54f324f1886fd7d3ebaad2cd60d3dc6ad5091a6389d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5d1d16729ea876e6b748ab034cfd1847afd9e797b78ab0eb235473f9ef8471cb"
    sha256 cellar: :any,                 arm64_linux:       "c5fe51a6da877d1f6abacce4264b59337ae546bdd7512406d822555beb7bf0ef"
    sha256 cellar: :any,                 x86_64_linux:      "e07f0a1514a0613c6d579f3fd0a3e48d30560d1a1d85dab7facef7981f8a5aab"
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