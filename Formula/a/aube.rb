class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://aube.en.dev"
  url "https://ghfast.top/https://github.com/jdx/aube/archive/refs/tags/v2.8.2.tar.gz"
  sha256 "17d1bccfca0d6c7ac5126b11ce685c5359380dc8e522c5d3e943dc1f92ea8fce"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9bb6f26bcc78c65881e16510ce9f78722623f68e14e27cb4977cb224b8de80f3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1a356fea7843a7c49632282f6ec3bf928ed31a0e96b3907507e9b553373d91f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4eca0f963054112df4d1a776e5f8e77f3a4ef567e490332711504b268d1823dc"
    sha256 cellar: :any,                 arm64_linux:       "d06203be376b1c9f988314ccae54cd1139c2fbcd0abe199d248bb0a9b979361d"
    sha256 cellar: :any,                 x86_64_linux:      "a414d07e83974d6651494ea091373bf8077841614acc0495c13a61b6ad9eed09"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "usage" => :build
  depends_on "node" => :test

  # Test installs a package from the npm registry
  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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