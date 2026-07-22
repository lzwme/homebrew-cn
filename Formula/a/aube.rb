class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://aube.en.dev"
  url "https://ghfast.top/https://github.com/jdx/aube/archive/refs/tags/v1.31.0.tar.gz"
  sha256 "d49b8548a47ed387c00712f19e5c3e7dc523d868a811f16aa061577738737ee3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "55d1530e32ac223b1ce1301d0b986ed7c83fab9323c915f14a9c6ae56b76b1d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "649a5b6d1cc06c247167135da2c0b3b10461c95566222c815ab664bc34117f28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09693be867ef684f6b0c236f39513e592ef7c92145eb50599de02f3e8579a093"
    sha256 cellar: :any_skip_relocation, sonoma:        "c176364365927755b0cee9a4405940dc732aec34f698b7334f2966874f496906"
    sha256 cellar: :any,                 arm64_linux:   "80c32ad85f89279456332ce5ab8d9c894ff6a2cd976d834000f6f781cc649730"
    sha256 cellar: :any,                 x86_64_linux:  "c187de4c6fb6bf837d65322b9e6356eea16b147ef441e32b7bfe043dccd68071"
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