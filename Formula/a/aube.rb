class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://aube.en.dev"
  url "https://ghfast.top/https://github.com/endevco/aube/archive/refs/tags/v1.23.0.tar.gz"
  sha256 "0bc3ee02d1f490cfd1f3667b7d1af739253886155fd6efd05db699ea789350da"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fbd9232270f01cfa226d2c20514adf9a1147024e03ebd7b15bd54d0a0d2b5c9c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df0f8d136fa4f56cee80cda6a22738e96037ef94a29c24e3a9f7994e0d0f1d0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fced3d8dd564244dddf5058a5584c7a2d16afb9a02284b1972debdcd79aa59fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9eca25fb41838c6145abc81f0fdac3578284d06eb064e1834c34144c6e87181"
    sha256 cellar: :any,                 arm64_linux:   "65fc790a7f445e13548f5b705c4b6ed6a39ef2fe767391df230b37a058298d7c"
    sha256 cellar: :any,                 x86_64_linux:  "9555de05c22fbc883317acd7fa3440a9f7980ce51ace8d333fb4fc4c55922797"
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