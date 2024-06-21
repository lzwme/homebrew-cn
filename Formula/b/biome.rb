class Biome < Formula
  desc "Toolchain of the web"
  homepage "https:biomejs.dev"
  url "https:github.combiomejsbiomearchiverefstagscliv1.8.2.tar.gz"
  sha256 "8f90b36de4aa65b671ff9f09df72b35ae97c0429be48b2bd51fe4423d9f2a0f2"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.combiomejsbiome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cliv(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dbbbb59128aee2c895c46fe11aa55099d593d665bdf0d9918dc9a155706d315d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9c104a58f68caf4443177ff5cf8584374db32b66e152906ba10e243c5a2b392"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "432d6ee9780f1a6e08404682df046734af2ce7de7ad71f6206025c2ef689111e"
    sha256 cellar: :any_skip_relocation, sonoma:         "72ef777a0d5c1094df0f2235163c0242b87996cd2c22d5cf5d585922780f6ff3"
    sha256 cellar: :any_skip_relocation, ventura:        "1c6a29b6e9ec1d3a0b71dd148c02e21f4a710aaa0eb2be029de997df943d6007"
    sha256 cellar: :any_skip_relocation, monterey:       "f123eb7693622a3976e07be68875ebd7d000ca1119fc507809a73bce39dc65aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0963cdde877ac07a81ae775d5277a17f2e0413850d4eba220c55d15277f75a44"
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