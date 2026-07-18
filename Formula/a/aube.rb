class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://aube.en.dev"
  url "https://ghfast.top/https://github.com/jdx/aube/archive/refs/tags/v1.29.1.tar.gz"
  sha256 "310e4d6213efc9b1b513348a16720ee9b65fa99ce9601b3d4756e3ef4a4ca875"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a509ea7b8e782d9f9e376aa2735de51a1a481ca8e15b4c8107cdaca23e92a7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df163c211f2abc71e26f32d98ea0f3d13fa6e1302de0cb320d8bceb8b5d8fa8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5aee103035003424157650284285feb930b183f1a05d8d70166dff007cc904df"
    sha256 cellar: :any_skip_relocation, sonoma:        "aeb3b90b8afc647f41b1ab5f5d9446496c90246e9005a6d59321c152dcc6654c"
    sha256 cellar: :any,                 arm64_linux:   "5c784a0776878f2fb5a0dbb866dd77a55340997678315a4861e66b15a1812d66"
    sha256 cellar: :any,                 x86_64_linux:  "a8114b963b0763d570631f3a02f52fa4fe6a17e6fbf94049f91670d61535e1f8"
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