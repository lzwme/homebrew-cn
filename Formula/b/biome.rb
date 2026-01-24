class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://ghfast.top/https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.3.12.tar.gz"
  sha256 "f86ee07054d71681b081994a42ca094592bd8afacf3e72c32a31f53e77dc690f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "018259673ad377f6113e8cc31e9eab9ab6ad0be73a89558f79235013ad53977b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c2defba1003f001650422b085645268567cb1319ac68c13f64e6228cc883249"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e47d53b85a5bd486dfd64ec3330e42d7f926ee64ad305a27e73107870ec536c"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ebfb546dcb6a0c7552f7b7a60d09ed0d17f1fcf4d95241bbafecdcc8c4e8e4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e77537e59e852d7cf586fff847d68647d7bf3a6910f80301359a7186d1abcc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb064db460339e8ae1d0176d7c0740c4d6788f15d30f6e0b3cff1c71b995b9fb"
  end

  depends_on "rust" => :build

  def install
    ENV["BIOME_VERSION"] = version.to_s
    system "cargo", "install", *std_cargo_args(path: "crates/biome_cli")
  end

  test do
    (testpath/"test.js").write("const x = 1")
    system bin/"biome", "format", "--semicolons=always", "--write", testpath/"test.js"
    assert_match "const x = 1;", (testpath/"test.js").read

    assert_match version.to_s, shell_output("#{bin}/biome --version")
  end
end