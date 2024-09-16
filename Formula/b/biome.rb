class Biome < Formula
  desc "Toolchain of the web"
  homepage "https:biomejs.dev"
  url "https:github.combiomejsbiomearchiverefstagscliv1.9.1.tar.gz"
  sha256 "6a15b00a484211a8a0de8222968b10e1838bb502b4209691762d471767850c3d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.combiomejsbiome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cliv(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac3cb09a1861604d0134f310411d25e59a626d05e963215c7cd6bae3431c29e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b196bc7e0e438782c9d1e071fdc5a6c30bf668707cdebf2fd831d3750035e5b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "52b5d67c0cbcdb47a1d5f3e75ae1cced4da95af231f076a90acd2332afdc3cb8"
    sha256 cellar: :any_skip_relocation, sonoma:        "e15cd01e71cee61299459ca1b996f81375b8ec9998dc67829f880235ea53ad1d"
    sha256 cellar: :any_skip_relocation, ventura:       "fb7bc60f6d11b05372e7a54bbb82fd5e4714ca4d71c9fb9e2375273da68e7fda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd025059040e2f87b8aecc60c9ec92c5e003f18bb137f0bbade5c46b19b4c2f0"
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