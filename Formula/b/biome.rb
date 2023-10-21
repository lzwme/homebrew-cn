class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://ghproxy.com/https://github.com/biomejs/biome/archive/refs/tags/cli/v1.3.1.tar.gz"
  sha256 "8511bec44ec1b90ab208b9aeba209e432400180bfd87ed6aeaedd7357f542a44"
  license "MIT"
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "336ecb68ff1f171d90280b8dac325a2201f580a797ac1ab12eedebde5c1d8ac6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0889d33cd3d7ff4763649e1ab86c59d795ede787996d1c8443b88bcf50f9d092"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c443708da407fdeab07be22130cc973bee692fa4e9d47193439fe66a3776363"
    sha256 cellar: :any_skip_relocation, sonoma:         "05fe59a6c034148b2980ff4a3de8f8ad5eafb6923a760086b1460d597f005aed"
    sha256 cellar: :any_skip_relocation, ventura:        "af4946b547f8016217ddfb4b9712e185b1cb990228a3cbe725b3a2f208b59df6"
    sha256 cellar: :any_skip_relocation, monterey:       "4523e8f6327421b88dbd9019e682feed2b41f98e623b7b0c890d1a2c37d7428e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1123df4e39264f9c1498d1f248dd30a2a87f13d2abbbf2dc42625d733c4820a"
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