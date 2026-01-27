class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://ghfast.top/https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.3.13.tar.gz"
  sha256 "8daeeb9e0550ebd10364dc6f990e6f321ac1f25d955317cd6da4813e920e498b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d28db1df93715d2caeced6d11243e3c448f225d88ad4bebe7e912bb185595802"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fea87addc997c070832e76ceb87c6f5aa5f9dc2807204a4ca967a426fb822bc3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bfa4877e288eaf640da4f0700bc0a1d81143c22e24779ade9f30ecd961e0f218"
    sha256 cellar: :any_skip_relocation, sonoma:        "3fc20b5f21442e3f09741d46f335c98d348d10e3d5f03d0ccf5bf7746213f242"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25179dd5ab31c382c5b58e2e97b5953488f7c39172cccc8013cbbf4d5511dcbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "078f972879e895bf5c60cdbbd58a2f0ed1c32e632ca6c29a364de082f908d238"
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