class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://aube.en.dev"
  url "https://ghfast.top/https://github.com/endevco/aube/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "b43ea54a227bbc4e607e92c9ba570bcebad88a2287e2949a71acee3e70ca153d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5faceffb1eaa1176606f4951dd12dc15a2d7231ef1d4a8c360dbb61d1e194d6c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "efa656d5ea8c5369114a2c89ebb3fa4cac78b6f9366c4fd8b76f428d9773cef3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19d0248b88f3bece7337cf5297c65298ea9bb80acf91514ac7aa7f32fde5f876"
    sha256 cellar: :any_skip_relocation, sonoma:        "9df971564ed396ba8d4fada744aabbec4f9d72f9373de31d1fb8b3f90b57c35f"
    sha256 cellar: :any,                 arm64_linux:   "9cc4ee6673044dfb1094745f0ff6173a310efb02c798005c808b8bf0cae9a8b5"
    sha256 cellar: :any,                 x86_64_linux:  "5cb04619b473597e052f6fedee514259daf0c33d5b8e37ffb67ef31304c9eb29"
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