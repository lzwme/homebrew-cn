class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https:oxc.rs"
  url "https:github.comoxc-projectoxcarchiverefstagsoxlint_v0.13.1.tar.gz"
  sha256 "1f7370f46cfe7def021029c16f033b596b36ba7dd55e84a137bb2911657e3782"
  license "MIT"
  head "https:github.comoxc-projectoxc.git", branch: "main"

  livecheck do
    url :stable
    regex(^oxlint[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ab3dd7998e01ecbc3daaf58b4519fea30aae1ab042ef2268f9316ad67ece5b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cfc7a03f95562592cbc5d2f453f7e0e9d41bebf2ec454c448f3da20083ec53af"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "19f7b920f4f551837f102b25da2a2d607ce1e568ed8c28f73b15a4f88b343e35"
    sha256 cellar: :any_skip_relocation, sonoma:        "01f2937801289116a54078d4649eeb9370f6aa5ff7d2926dd07bf2f075bc3620"
    sha256 cellar: :any_skip_relocation, ventura:       "8fb3fdd8c7ed5900db371182dca2630f69b0f4a4041d6f68be73fc569f45027b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b9dff4defe5061c3faf1aa6c478ed79cb45878b81bc3f05d60f22aaa94b38ee"
  end

  depends_on "rust" => :build

  def install
    ENV["OXC_VERSION"] = version.to_s
    system "cargo", "install", *std_cargo_args(path: "appsoxlint")
  end

  test do
    (testpath"test.js").write "const x = 1;"
    output = shell_output("#{bin}oxlint test.js 2>&1")
    assert_match "eslint(no-unused-vars): Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}oxlint --version")
  end
end