class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://ghfast.top/https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.3.9.tar.gz"
  sha256 "fa184460f7268aeb65c75325fcf78dd046cc5e1460ce7999513348a95d8efbcb"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b491bd7537d6de4994ed9e1ac22dba2e478ddac7bbfd87be756cdc66415e8356"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f773d435bdcee70e954ce31db4de625b8a0e4c922ea9313ce4ff0cac6272b5ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "857bb8bdb763606c6f4099abf8e89f9a9e4e08622f7b4c79e5a67eb55857ca50"
    sha256 cellar: :any_skip_relocation, sonoma:        "515de451195b74d0700a71b87f20ea16d52ac2c1b090e65e7911751467813bde"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "431da7b83b4bf7f9406caf9b4908aac6f826557e3b1be7bbad89f34e39906836"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcee42d17a52ad6eea4d1d3e0541d0b77b702c40d87c4dfd4ba1ed0909e1b557"
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