class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://aube.en.dev"
  url "https://ghfast.top/https://github.com/jdx/aube/archive/refs/tags/v2.2.4.tar.gz"
  sha256 "4e745ac1d2a51a869ca3f7761cd7892c6a5cad6c401e7c142bfbcac549a9092d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dceedfdcd02a8436c675dafcc0b4c869c5a1b2f8de345f7c6e0da7743d41b002"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3576bf81cac71a5c251c7f987a0aa5442ad5fc9129e8a7e282c543aa7ad10c6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d30cc8bf9ceaa944f0f81b67f81c636306a70236f486ef13366aa103235fce87"
    sha256 cellar: :any,                 arm64_linux:   "706db30abebdad0a0beb890112f1ffc1129b5046c34bc31c18481aa9d9da9757"
    sha256 cellar: :any,                 x86_64_linux:  "d93930671dca6734e8ecd4da4708abb689c417cf749a4fd77ff60f7bf0bb639e"
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