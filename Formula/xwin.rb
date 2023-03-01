class Xwin < Formula
  desc "Microsoft CRT and Windows SDK headers and libraries loader"
  homepage "https://github.com/Jake-Shadle/xwin"
  url "https://ghproxy.com/https://github.com/Jake-Shadle/xwin/archive/refs/tags/0.2.10.tar.gz"
  sha256 "4652aea66e7492fab52d35a1ad8ca8f00057499487ed5536d3fcb8fca883f234"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e951d6957329934b6a47b7326b4d6872eb8cf798bc94e110bcde2a707b7dcdf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "818f0c238aca8ec5dac057d8c7152e4d906462c8e0a3f932ee515efca8ab9541"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0d9e0c19afbc01f54f87f6f29923358eadd8e0fa5900fc4a768bf33418139d9c"
    sha256 cellar: :any_skip_relocation, ventura:        "2f5ffb3b80e0d42c4a5c71286d65164373b89ac6fe19082d1584a978db755b40"
    sha256 cellar: :any_skip_relocation, monterey:       "6479a568886dcbe017345fc35107c91c0df823bc5251dbd5088ca5ad97c2f223"
    sha256 cellar: :any_skip_relocation, big_sur:        "18d8d5dbf7a3ceda633054c4c8eee7c64558516e69c40fbf821a41b3b302ed31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0bced955560a18f2c2dc9c9425e7b40251a1e73ed0bf6887b4001ce22ead4222"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"xwin", "--accept-license", "splat", "--disable-symlinks"
    assert_predicate testpath/".xwin-cache/splat", :exist?
  end
end