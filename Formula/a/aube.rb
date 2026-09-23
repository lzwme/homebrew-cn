class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://aube.en.dev"
  url "https://ghfast.top/https://github.com/jdx/aube/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "1c1bcb9e4bb93a8db2e7292c44aef8b90c5454f50d3542dffe33c1e1cba9fc26"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b6c7843e26befe4e2e29ab50d54a2aa72ad492fcbc10fae9f9399fa7c35b2e08"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9480d4939cdaaa651a1d1c860c43fb7101a5f10b668fed1e7b4801dd00a42bd4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "904a25b2f6fca91827348ebb92e283cb697833cfb48ac522c3ce706226767456"
    sha256 cellar: :any,                 arm64_linux:       "5f67836338fd44404a37d71b171cbdf47a794959c1cdb4435db6b413457e7fb8"
    sha256 cellar: :any,                 x86_64_linux:      "54b686286c4e8656838e9f8b086e4eb99da277deeb51777f50762856a27b898d"
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