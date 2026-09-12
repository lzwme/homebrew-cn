class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://aube.en.dev"
  url "https://ghfast.top/https://github.com/jdx/aube/archive/refs/tags/v2.2.14.tar.gz"
  sha256 "f48fac2f7b00d85566f63484e09f4f18dc697700aab784917ae81e7870c03791"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "54129a3d24628932b9521dfca6143ab89da15d4f083c547dcb4c68ef669a86a1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "090603e108e379866023eb8dfcbf5005c3ae98127aea147515413e08313b7f3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f366e5bb9648f8a53463b0fe81e8b82880fc423d4663b3e4090e57383190321b"
    sha256 cellar: :any,                 arm64_linux:       "69eda97112ef4fbffbb2fcb6aa18f46824f32e18d23a40d383c396a480af4073"
    sha256 cellar: :any,                 x86_64_linux:      "eccd83d7b5f490e6ad4f4b234f0277179b3ae9dbb0d957d7df03c7d3e5bda207"
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