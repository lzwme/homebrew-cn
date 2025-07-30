class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://ghfast.top/https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.1.3.tar.gz"
  sha256 "1b9e7227cd27827e3951054bf8daa1a8b42c6a53ab5c05de20f62719332f4356"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d6b95387fa2a698b41a412f75d09991055168df75d03d3c1dcffd5239d44ce9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9836230caa03b4b757a99ec8fdf1d0f4bbe0b922c794fca847c09eaaecad65c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ace10425ff54695890eb3582efcca158f4cd7c4057ea81530c125a2fb39519c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "7dc33565bd633548713d92ef92c58f358deba52bf33413ee0db033ca4f65b9f1"
    sha256 cellar: :any_skip_relocation, ventura:       "8f7aefa0973cb44682b351321fedcad9dc1107df3d493330c6c12d72ab88e52c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a1baa3cd02d67d1c46fc812232bdef5958a5c81b2dbfb61e27dcc4f95148486"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b67127bbda52bf98ccb7c8792cc047bd9a8b585714346ef43212f520c926f90"
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