class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://aube.en.dev"
  url "https://ghfast.top/https://github.com/endevco/aube/archive/refs/tags/v1.22.0.tar.gz"
  sha256 "aef37c9658e427269f3f5c26384b43a83233bcf403c337794fa1ee66d8478cef"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "875034d106a31d6c94caddc35b6a2a18a0c5a514ecfe06dc0d0e2bb598734a31"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c955134ff69d67324c59b0ef8be64c3adc8037d24dd93656a2a2bdf55ba34f13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "723c065b63ac50697397c90207fea328de9757a0ac6c76e859a8e4c53819fe26"
    sha256 cellar: :any_skip_relocation, sonoma:        "1787be1d5deb726b24a51da4f9360de71ff4b49059d5d4e17c884eb5613d34c1"
    sha256 cellar: :any,                 arm64_linux:   "d67096f92be4dc2d127fdf8885c3dc49d3dcf90924c38f4e3243f072cccfad9f"
    sha256 cellar: :any,                 x86_64_linux:  "8eace81d73d7d79a46c0ff0b21175018a7b6c8abcdf152412e58f5a024a86676"
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