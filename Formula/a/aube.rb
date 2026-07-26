class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://aube.en.dev"
  url "https://ghfast.top/https://github.com/jdx/aube/archive/refs/tags/v1.33.1.tar.gz"
  sha256 "75c2d4be53240962fdbfc80b3274f1c9a2281e4bf3ff7014029a6b87c67719d9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2bcafadc7574efa1190f5277fb166b34352126160501ed0f4b7be149dcef71d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e59bdfce5cf6410e4013cecf3603881829311b6a3017427160a06be81ba8683e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f1416a310cf7b32b70c5daf37c2bd30b035917cdc2e67bcfb6b57f9a5327558"
    sha256 cellar: :any_skip_relocation, sonoma:        "196878a58e29ddce46cf71a45165d1e500c3eb864bfdc5ab3d20993bc6d9e5af"
    sha256 cellar: :any,                 arm64_linux:   "6d62eb2d0315531e172d81e4d0412fcc3a6769ec21ee639e203c0cc4477559d1"
    sha256 cellar: :any,                 x86_64_linux:  "02ee4ee69bc08a0320830db5352db40e6af994a7ce7881df5f894d82b8ad224b"
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