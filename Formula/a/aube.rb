class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://aube.en.dev"
  url "https://ghfast.top/https://github.com/endevco/aube/archive/refs/tags/v1.25.2.tar.gz"
  sha256 "d9118c1fd98d667f4bd8f63a6701816b0c0fe2f680e29e6d9246ffce634c649a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71b055dc5856680ca4f8aacee45c44cbcbffab7e7d13f502582e48ac81a16905"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db6ee978e4f8cd1a248d06321edb913224689bbc9a25d9670bafae498d21b96d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5693fc62691468813818342f4f2c343a6b1b520e6b77a1c8ae83b3ce0e593d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "c90f3db89e76656e2e75a21356ca7c9470d74def3c1bf61d4b4f77c51c42dab5"
    sha256 cellar: :any,                 arm64_linux:   "85df7b576684c250a4c4f5b71663153882fe07bcb448e00fefb3b2579c521a8a"
    sha256 cellar: :any,                 x86_64_linux:  "b8ea1a10fc2d347dcfc2498309e740dbae0598dc72f7ee9ba733483e8baba21d"
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