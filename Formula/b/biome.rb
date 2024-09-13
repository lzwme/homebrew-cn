class Biome < Formula
  desc "Toolchain of the web"
  homepage "https:biomejs.dev"
  url "https:github.combiomejsbiomearchiverefstagscliv1.9.0.tar.gz"
  sha256 "7393b63c747f844e1a3e783ee26f880b0da3d798e4fed72ae7dfc29186a503b4"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.combiomejsbiome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cliv(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "9708b98edc4a87692efec28e91e567aa761aa8a070307f0f25f56f95dbc08817"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6e2ff3e4d52c1a1c3a4543cb8ee9dc7cb09cec6d03a110f7b85dbc28fe769271"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fb6fc039f46f2707b0aade1aac473fd8903ac55f847a1ad6f780eaf4983eafed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd19c75d6ae7167944230ff568a49f35378623152e139aaa7d41d36b997325fa"
    sha256 cellar: :any_skip_relocation, sonoma:         "0345801a6f1429cfa978adc698ccef55ba08d4ca12af4d538920ee092397f879"
    sha256 cellar: :any_skip_relocation, ventura:        "168f2b9b1d397d7587a9f620fb525dc18781b8f0800e87b3d6108f6b3b42569e"
    sha256 cellar: :any_skip_relocation, monterey:       "33bbd9ba840ca2cf13eeda0fc7210c82954466afbe0718611f080c639c2d8d47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c1da266bed5ab516123aa4904c8913ad4a4949f4a8c4f41215348f1fa09822c"
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