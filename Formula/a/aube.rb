class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://aube.en.dev"
  url "https://ghfast.top/https://github.com/jdx/aube/archive/refs/tags/v1.38.0.tar.gz"
  sha256 "3975f96fb0d1b0f954c6353999335155eb0e38e941248b84da9a319f7b2acf60"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "64b5691fb1a1dedb1c6440c78f65917e7433810a131bf860e69ebbf5083dc621"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e318852c47c0ae4c0da993f2a26a91c3778f4be30e6f6bf04b855467ee04e5ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c08c8d5b9ef61476c367ade157bc78fdc282b0151b8891a48b66767fbba667e"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f452fba62d6f4a730481cb216ebf12799dde99df81ddccceafe6bd38990f060"
    sha256 cellar: :any,                 arm64_linux:   "6778a62df25535ad0af06f9dfd617f83d99841c1c804fe5c4a99dcff4c243846"
    sha256 cellar: :any,                 x86_64_linux:  "b226565f855bb019cdc481917d9b9f5c84410fcb85d2fbd287d8696e285d0357"
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