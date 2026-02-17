class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://ghfast.top/https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.4.1.tar.gz"
  sha256 "5f8bad63f9c028f1a66d2da4bab386b4f9b2934d37da5515427b35a7b4458c94"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30a40fe580f62fe845ef6fdd841c201322ce6918916d9dbe964ac9b226e849f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66e569c36f042b050ccbe8eb03a747eb93d6ca2b1b96f62c791b851db3aeafd3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a981c491e9b069146f478da49bd8a2063060a4eb66f2f8306c0f0012c69fbf42"
    sha256 cellar: :any_skip_relocation, sonoma:        "513d4027f5499b7504b3ed726c407086f336c97f7c7a4a98d16074fea9eb8b0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "308bfa1d0d9c3fb74c81af1bbd6f2ae3ec2200f173070fde91d19ab1f7592ea3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58b2326572eb7e06e4f6597a8987ff04e30d2b74c0a61466cf9396afcadc13ab"
  end

  depends_on "rust" => :build

  def install
    ENV["BIOME_VERSION"] = version.to_s
    system "cargo", "install", *std_cargo_args(path: "crates/biome_cli")
  end

  test do
    (testpath/"test.js").write("const x = 1")
    system bin/"biome", "format", "--semicolons=always", "--write", testpath/"test.js"
    assert_match "const x = 1;", (testpath/"test.js").read

    assert_match version.to_s, shell_output("#{bin}/biome --version")
  end
end