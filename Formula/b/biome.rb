class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://ghfast.top/https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.4.7.tar.gz"
  sha256 "076fcc3eb38c82e85db6f0a238e09d840d559ecd2ddd196bd7851a51438ab7e5"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "872daebf8bdfb49e35155f0f62caebb1e28225481b3dd63c53702fe546949a6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7bffa090e535af582149beb2f5a889d01c410fc4317dc810adb51fe3ac41802"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63891df9ad0175098a15b23ad14612dc7384579b3dbd6e0ed594c56a1852fc9c"
    sha256 cellar: :any_skip_relocation, sonoma:        "e998acb71586b5d75163a46d6603d41b502320be3db653b4d24a49c624771737"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36e7823a5d8660cbbfd2d9a1a1527eb668c3198d158e77fed5be91e790d994dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf66b40b2acbb1441121e1b2a99422f177dfffc2b161afc686cf7e68e9568e38"
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