class Biome < Formula
  desc "Toolchain of the web"
  homepage "https:biomejs.dev"
  url "https:github.combiomejsbiomearchiverefstagscliv1.5.2.tar.gz"
  sha256 "0fcadbf7454285a2f6380d33dddc04f86b5756431570c15d9292989037bf4910"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.combiomejsbiome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cliv(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0f65682d52eb66a8b5704a89534645c91f8ced98520748e73776edba62094514"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f5d5bd36148332e4fd30cc42e417f4bac5d35ce4d10aa28b824d30768968bfcd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb22c697e930fc44c326406e387769a6b84e149bd6597f1c83641cda2086b910"
    sha256 cellar: :any_skip_relocation, sonoma:         "0dcc3f124d7c3866b73b037ff5e3432df9081048944c42b232ab7b15ae9b5044"
    sha256 cellar: :any_skip_relocation, ventura:        "b685a3ecb9cf3f2ac819566e1a4fa043df9fe2c011ccc16f9dead532128a8370"
    sha256 cellar: :any_skip_relocation, monterey:       "d214a66ac87f96c6798a5b3745f5263c52785d2f0781ecb7bf23c9ec64535ab7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96db6b74bb2074a4b43feae837edf4842701d3b58c5ec298b7e4750d4a3466cc"
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