class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://ghproxy.com/https://github.com/biomejs/biome/archive/refs/tags/cli/v1.4.1.tar.gz"
  sha256 "781f0ee672c0c9bf465739b4cc56a924d92ec774f7c78561d136d5f385b09362"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "79b08deddac6f3cf238c4f4effda3b097782a6b6c4785de46a93a9d86bf2dc22"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "046c42d5cdfdbf215b563090bd23a1d547034e73dc7f448a4b4b2f0e6ed01520"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60774bdbf3377bd95ffec184ba82e0c4589f2b96948a4536c1d0e9c34f32591a"
    sha256 cellar: :any_skip_relocation, sonoma:         "f457ffbc169a9b8700ab606b9cee32a75aa90697375c701d9a83c00671558336"
    sha256 cellar: :any_skip_relocation, ventura:        "dc919e2465a99d3d14f0330dbeab12964bf0a459f9762d375ef8b36c883c277a"
    sha256 cellar: :any_skip_relocation, monterey:       "db43f55e6b041cc6af8839336fb5c2e49ebe5229b312f23445c5ff4b7a32d753"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6bdc1549a7d2550d6316074b1afa2ec454894d4624ce168b87687c4adbb5ac0c"
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