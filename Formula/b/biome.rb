class Biome < Formula
  desc "Toolchain of the web"
  homepage "https:biomejs.dev"
  url "https:github.combiomejsbiomearchiverefstagscliv1.5.0.tar.gz"
  sha256 "4d1ae725112f5df6979a8ea97a233f1a46424c7a56b2d81e24a5acadefe29eb9"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.combiomejsbiome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cliv(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d22bf12525d57d9658f7b1628164036c2931d1ff39c6a325fb27fe05d00717d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f582bfe8b0754e7faaf7752977e0e048e3bea5f49f6cd7ce8fd8e49d8602105"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7857b42c6e90bb26021adc315427533adec8a88a9ef53662ebc2a71acf44201"
    sha256 cellar: :any_skip_relocation, sonoma:         "e8b065bc0791ba972d065282e90c7bd2e6bff2d4c98ad0692a6b4170f0be7792"
    sha256 cellar: :any_skip_relocation, ventura:        "2e615a4e7d913509905688d9f96ac601f269fc12be0147ae02235f27187eb4b2"
    sha256 cellar: :any_skip_relocation, monterey:       "a62af39c4d8140be397c7fd228071d64d185e42de43491a73688c70241d2b5fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14aeccbfc62c66ab6bb08dc418703190919016d79dc31284334a66223e178f8d"
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