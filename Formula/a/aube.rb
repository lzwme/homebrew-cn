class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://aube.en.dev"
  url "https://ghfast.top/https://github.com/endevco/aube/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "41db7450c0df1b37d9d10fe9816689bccb004c14c8c503d1279f6cff59bd81b5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f800fa5bbad07d7367a3a15623b68ae2f7ed47410109e56a8364fe903408ac91"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8b7704da5c03d1296355464bcc7c109560c64e8e2c9f6766d0efd7e8b21afa4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1bcad6d9ccbb0fabfc1926321ca1461af6362c98856fe7dff997612db0fe835c"
    sha256 cellar: :any_skip_relocation, sonoma:        "03a74731d94c55689d59ddd9ecb76ff32d76fb468caa9ce3a26648ef4d8b8c5a"
    sha256 cellar: :any,                 arm64_linux:   "3db7bf0572412856b022bdd2c54bde166d181d66f8643e5544bf1814c95e6fe0"
    sha256 cellar: :any,                 x86_64_linux:  "8ab3f203345e7db2d23c0a39c5baa0253bd5f4d9b4d7f6ec892c8b0d63b62fc6"
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