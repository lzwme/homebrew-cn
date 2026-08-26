class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://aube.en.dev"
  url "https://ghfast.top/https://github.com/jdx/aube/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "460843ddc3fb534b5c4ec472be914f9b6a45298378347ec55f0cb0696d4b0463"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1549a4a910f0b2659c3d8015c336b2172ad0cf7bf75206d66135be49586c30d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8c7feac854d1c4c91394bc5f18adeed14544f5b81d223107b6a87251f28d841"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89847c02bf0890bd056fb781b2c2c8cd2639c77f1cf95a4f5ab203dc3d70d7a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "a7ab883949968d940723f7f8a0498d24e561e321b1aac8e4ae3579ef69189491"
    sha256 cellar: :any,                 arm64_linux:   "9a297441af88a9b50cc4036030d6355f7b295c2c6f59de71186caac4d7d6a8d6"
    sha256 cellar: :any,                 x86_64_linux:  "4ce61a99395671c07291243abf9e5a3a6c4942789c6ef3c70fb32ee138ebebab"
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