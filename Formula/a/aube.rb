class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://aube.en.dev"
  url "https://ghfast.top/https://github.com/jdx/aube/archive/refs/tags/v1.36.0.tar.gz"
  sha256 "7e11c554fccc1f3d82fbb3a560206d51b058e8f5c8fc31b8f14eed3750f8e80d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac992f7a3e3123f1ec9e04fe66a356dfe4357d65609b824ade3a427f162450ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d78b6424cb6b83fb13bdf12498e75f6f8242d262928c89e7400d2b7d6591f00"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3ff080d3233debaac2c6714858772bbaa25a342aa4b25b9726e7510e2071ea2"
    sha256 cellar: :any_skip_relocation, sonoma:        "e23a711e60e20abe421bd34e1317c9b8cd658a4e1a03436b88ca211c5f98d85c"
    sha256 cellar: :any,                 arm64_linux:   "9ca0472cfe24655e34738b1ad26eb2ecf0ccc153c5479ecf5074308489be90e3"
    sha256 cellar: :any,                 x86_64_linux:  "6f0703841e70a3d712bf5c2d8560d810752dde523815be385c0e0cc46ab631d1"
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