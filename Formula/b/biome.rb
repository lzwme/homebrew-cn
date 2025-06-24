class Biome < Formula
  desc "Toolchain of the web"
  homepage "https:biomejs.dev"
  url "https:github.combiomejsbiomearchiverefstags@biomejsbiome@2.0.5.tar.gz"
  sha256 "bb6e8c9692e7efd7e36f78d2f4f9d48c2cbc3f876ece716400eed024f42a2f15"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.combiomejsbiome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejsbiome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1afe5e2090c89d15f3a0176fb9207ee50f4f8732899d6ed3815be5d261c389e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0cb8c35ad8e64861e203aa003dad0ef164ccd3e19117c18b697efb706b9d844f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "345fad4f65dcbad8860ec9122a4a10270e2387d4450663ceea5f787adbcacd90"
    sha256 cellar: :any_skip_relocation, sonoma:        "0bf95dbca04121549ca5fd1be9e59f46c1e50392bc97a04aa45aa53412e1c699"
    sha256 cellar: :any_skip_relocation, ventura:       "26c2fee2f48f41d705736e88ed329df63f1575973633f24a6d398cb4e95be71e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be21cf9825e1dfad8c70fdc854625bd8d8cb9f4d9fb4897c3c77bec4d8259bd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea8614f571e18e0bee2059aba232ac0cdfb01cb1c672029c26315ab5a7598a70"
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