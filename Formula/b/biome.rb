class Biome < Formula
  desc "Toolchain of the web"
  homepage "https:biomejs.dev"
  url "https:github.combiomejsbiomearchiverefstagscliv1.6.4.tar.gz"
  sha256 "a613e2f782bb93e1dfa2b03d09d8c8f74020704dd218e50e17d7e9af97c0d4f7"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.combiomejsbiome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cliv(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "71ab2ae2de6c76976708c4b61c159c908bc363b142b299d3aca6cf070e98f3cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ecb085ee070537eec42e047afcf194bf81ea4582b6112cc436369b0fe9389282"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ba11a159a00d127a7d0c049a08a8f5c2a66b4d5e8ac93d448b35aaddb2ff5ea"
    sha256 cellar: :any_skip_relocation, sonoma:         "eeb918e36a4c1d78ab66c15797bad92dc682ae83b4318a2b643d6b31cec4f6c0"
    sha256 cellar: :any_skip_relocation, ventura:        "be8b462a8cf9f57b16fb357909f797663dea77824adbc1021bb51361365cbb11"
    sha256 cellar: :any_skip_relocation, monterey:       "272b91ea604473e14a5974952213ad2cbd122ce71356a5d4b07ac1d5e67da060"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "336bedd05e8f4c8caa15694a9d3286e52c2e5ce34951b237bea74ec2123775a1"
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