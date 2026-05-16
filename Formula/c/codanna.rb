class Codanna < Formula
  desc "Code intelligence system with semantic search"
  homepage "https://github.com/bartolli/codanna"
  url "https://ghfast.top/https://github.com/bartolli/codanna/archive/refs/tags/v0.9.21.tar.gz"
  sha256 "9884d00e0076ed28f9671b615e674c38a073e0b5f7b7584b732fed6d1de263e6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b07242bf4a8c7e25f815436edd21c3c418d76b674ec15f22d24534f6ac61285a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ff08a7847b02fb6e8ae702398d0b66a0e1386887fa94946127007b0f5239aa5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2ed7c88e925a278c9446b0db8fe77dd4ee6d60b3b8a708313a77a6f5be4a278"
    sha256 cellar: :any_skip_relocation, sonoma:        "2218fe043a63a30b55b0c8b2b07487b0731cf16eb8bee729e9517914cfb53574"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1aa8267a58fe449f2974a212a104f539084653d90f6f114c9cb81eab31441b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c696f37ed88673ebf8ea1cbff358fec9c70930111f169028d6525e9f3cc2f20"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args, "--all-features"
  end

  test do
    system bin/"codanna", "init"
    assert_path_exists testpath/".codanna"
  end
end