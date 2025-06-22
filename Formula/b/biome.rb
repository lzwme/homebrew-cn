class Biome < Formula
  desc "Toolchain of the web"
  homepage "https:biomejs.dev"
  url "https:github.combiomejsbiomearchiverefstags@biomejsbiome@2.0.4.tar.gz"
  sha256 "22b0af2a2cd09b5ad68fe28b352657aa29907d60e0119b64712699d49af50f95"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.combiomejsbiome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejsbiome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84f558da423fcf12f9706ecd8c18c2275cc9a1b0893f68bc6fcdcc60a4ac9b77"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be234f1885348b28d95fe4ce679326c50905e4b32e06c0b101df31eb5dbd1c6e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8e54e21ec833e9c09dd3e491e7e4167d5e03604ca2db5b728487a6c6d6038b84"
    sha256 cellar: :any_skip_relocation, sonoma:        "2bd0a7b6a306479e1423cf82393fc8bd9834e57d8d9b24138d350284c1bfd08d"
    sha256 cellar: :any_skip_relocation, ventura:       "fca8a17a629fe09d20a55443ac2423e0773114ee02a9b3786231a3d3f1da8010"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c15e6c0dd3fc1973c2d292eb4e9de02105e7a8606310fc518e3e9c42bde2bcb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc6483434862eb4c809141cb38a6eb29db2e85619a256ddde68b584a7c236dde"
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