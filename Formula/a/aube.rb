class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://aube.en.dev"
  url "https://ghfast.top/https://github.com/endevco/aube/archive/refs/tags/v1.25.0.tar.gz"
  sha256 "52bd926e6934e4b4da7920b6b85fadee1767872a6bfab1b793994208217b3b3d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b955027560bb353cf1fcf62593e2b50fd5f0645c0d2ba3dc3821f9866a4b9ad5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fbcd3f31bfcf7a5babc2d9620c12416a8611d66d19d38c8a40707ac9e1bdbcfb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de91194e97df01de9008e6954e8860f7b03bbc6a77ae850283a6ec3eff2bd139"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d31fdd2274a342e2088d89fe1dead2c67982d3d5db764f8145a6e0d8e77ac7b"
    sha256 cellar: :any,                 arm64_linux:   "069873c1c8c953a00f8fe2095012a9f0ff36cab7b38d30a81df13962706a66b9"
    sha256 cellar: :any,                 x86_64_linux:  "f8a60f4beedb652ac36beb2723b3dfcc0af2e633b8a3cd467e24dcc1e53dd719"
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