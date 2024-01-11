class Biome < Formula
  desc "Toolchain of the web"
  homepage "https:biomejs.dev"
  url "https:github.combiomejsbiomearchiverefstagscliv1.5.1.tar.gz"
  sha256 "ae38b6b995bb4f99dc36b42ed00004736735760bccb836541afb70e9100f97b4"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.combiomejsbiome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cliv(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ba2a121ad8029f9562f5531cb987d02dd3aea37654a3c24701653885f0da5f9a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a6b961714f2f56dd2e51f6e426edee4617ccee62e28b3541e6aed3ca58c2d842"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17fd54d5acf3db72e422c059b6a3194b207feffd2c9aaf37bac6f67948bd5473"
    sha256 cellar: :any_skip_relocation, sonoma:         "917dc72b35cd75f2b42a8ef8e8814151c8bbd3711fa3ac7527177d15dc8e5827"
    sha256 cellar: :any_skip_relocation, ventura:        "c3e2c6c679aafbc46813789615b72486017bf255d2a1d2cbbbb22db6131eacd2"
    sha256 cellar: :any_skip_relocation, monterey:       "7d5b8733e1a345f1828a899e0be6bd173004305bb53c08516d55d31e7abd55dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "988f8268c4ee36f84fc1c56392311a5c5ba223b1878ffa52aa224c9596e20ac3"
  end

  depends_on "rust" => :build

  def install
    ENV["BIOME_VERSION"] = version.to_s
    system "cargo", "install", *std_cargo_args(path: "cratesbiome_cli")
  end

  test do
    (testpath"test.js").write("const x = 1")
    system bin"biome", "format", "--semicolons=always", "--write", testpath"test.js"
    assert_match "const x = 1;", (testpath"test.js").read

    assert_match version.to_s, shell_output("#{bin}biome --version")
  end
end