class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://aube.en.dev"
  url "https://ghfast.top/https://github.com/endevco/aube/archive/refs/tags/v1.24.0.tar.gz"
  sha256 "1bcb1e4404604c7c26a13571343d011b4dbdd3f910b113d83f4dd5a055b45d22"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fdebda3641d1b109ca8ac35da3a1e73500a105f8c0822d6b4c2b62ad1f05bd6a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5c723ccc24e16a84094c854b44b827f6d9c5ee910d9d5d0c8e1d480b6c2aede"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d79bc996ccf3b6de26614d12a5801259bb9c52e4d37cbf438dab362fad7fe94d"
    sha256 cellar: :any_skip_relocation, sonoma:        "563e86d517ddea2ae7738ff5daa942c182d1fa5fce1a6eecedba1b4bae328d51"
    sha256 cellar: :any,                 arm64_linux:   "dd8560146f8a51d80c08b657e3eed6675114a759b5db33a174d42001a17a698d"
    sha256 cellar: :any,                 x86_64_linux:  "8b0c751d396ce3897987efef897723042b66ba289c769671452b297e68f2e3ac"
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