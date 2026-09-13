class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://aube.en.dev"
  url "https://ghfast.top/https://github.com/jdx/aube/archive/refs/tags/v2.2.15.tar.gz"
  sha256 "bf92bd3ce6c1419370867f1018e18e40c47e560105f0d72d99fe88e869c9df48"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5f332e3dd18a523686bb7a05bc918994403bb9a412954b905f3546f14162c29a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6eeea4a2e50c19ec486b30d3bb72e8fa2693123cabf9b6234e91b9eeb23de7df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "639bcc2486f6a90644ffaa105a6bcc913f4e8562dd125d6817b4ac17a708e86a"
    sha256 cellar: :any,                 arm64_linux:       "42eee4fa5ad50dcde78aeb836e6feaca89510f846abebcef18d5cc56c8a2792f"
    sha256 cellar: :any,                 x86_64_linux:      "3be5b3c6d4e671dc5c5cca1f66911469c569ab328a9f1227148639ed74405874"
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