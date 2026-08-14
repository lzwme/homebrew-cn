class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://aube.en.dev"
  url "https://ghfast.top/https://github.com/jdx/aube/archive/refs/tags/v1.40.0.tar.gz"
  sha256 "a836796d9e72ac8af6ad31172572a2f7919cb2481cd318a65e5e3e1052b5c429"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "96069895ce329177bbb36388b5c61b068e309e5134373901e432a8a109af5d26"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce26fdd01c819e192acfbd52ac1a0d060ec82d38ecb27fe62a12cde0a955d4b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ddc89d0b5120bdd31a74144b022001679b5aed998cb1c9683348e15135178b39"
    sha256 cellar: :any_skip_relocation, sonoma:        "b28fc31cf78b8af11610f22aa7216f630fbcd3670132f0382bcf34544b07b678"
    sha256 cellar: :any,                 arm64_linux:   "12485ebab1310ad50b51c57d9f18ca1b448465f37e2f15d53f7da91606c2581b"
    sha256 cellar: :any,                 x86_64_linux:  "df03bfbacaa03fac9575a52c76da12a90cac68b8da57b672f7515150cab89cf2"
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