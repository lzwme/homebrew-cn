class Biome < Formula
  desc "Toolchain of the web"
  homepage "https:biomejs.dev"
  url "https:github.combiomejsbiomearchiverefstags@biomejsbiome@2.0.6.tar.gz"
  sha256 "52d5e449346bfb15855a3bac85ba5d43b81d0fb1a99be9d4b7dca8c51521404c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.combiomejsbiome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejsbiome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "108bd949d40c8eb12902e41508430371e2b043c5f4ddfe38718a5e5eac715dcc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63355550a4863cd1bf6f89624e597ca75fafefa5e8a3e68e3a70c64e68b810b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "01130e08c3c2baac0ac659eaa92e07d3fd06ed5b57b105461dd3941f32df9a5e"
    sha256 cellar: :any_skip_relocation, sonoma:        "0daf22076edb8266d273012fc979b81ad2ed8acc0e25fa4fee06510da7866872"
    sha256 cellar: :any_skip_relocation, ventura:       "b052a932cee337cf29fc07e472b6135ff707c0641f55d64555cedaf05cf2c33b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f97e200d4c7bd591a4fc301d765adb13a9c47d3637cdd8febf05c375764acdbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1a18c660dc116ac227907f9e1a9ad7f21cf2774247b27140600b366419eb780"
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