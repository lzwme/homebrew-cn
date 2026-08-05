class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://ghfast.top/https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.5.7.tar.gz"
  sha256 "ffc27932058a51f3e357721990e5a348f4a6bcff5293862a24227568f91cce44"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d24bbbba9591864cbfdccd3cd609a50a1cb13364d715f18585aadf30553d289c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d266604d090ae2b576b1869b484c213a6f3fd2eba1e08044d580527f446f8ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f4bc836c8c4fedaecbfa6bf35e6879d88428b87ffec717da6b2acc73609c0f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ddbeee8468e5c88d534ac217a64e908dc86a3ab63ad95f21dd62fd04c069b3e"
    sha256 cellar: :any,                 arm64_linux:   "a7854b3616dba02b4cd84cc132d63bd189d0f77ad3abf35bfedbbedc02396cc5"
    sha256 cellar: :any,                 x86_64_linux:  "d13ff58b9c7f615a5d55f462158bb547153f84007a461a061d8c70d61defeaf9"
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