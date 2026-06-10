class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://aube.en.dev"
  url "https://ghfast.top/https://github.com/endevco/aube/archive/refs/tags/v1.18.2.tar.gz"
  sha256 "ddfce25e30b18e54dd63b4153e563abfaf1219e0628017ed7e5adf3fc91f38e5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9059fab830feee95d45bca6fae84a4d037dfe68c8f8e18e7327a8ddca00a2a10"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0588d169093539bb05fa8fee5cc429ce577b3e804ce26d40e62a8d4fda381274"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e89da8514bc9d0800a013cd47d92ff64ec09179d704e1800de67bf8d01284748"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f4dc767cd4593d1eb1522c9ae5981b23c878dbd93fdc45d41f086d5e6eb832d"
    sha256 cellar: :any,                 arm64_linux:   "341ffd6a4419a2ec948b2a22acd99ce7b0776e51c7920455984bb8afec0b0a5d"
    sha256 cellar: :any,                 x86_64_linux:  "25c65f47db90617c57024457c94e6a5334fecd563299f3dc27a4b4e2cad146f0"
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