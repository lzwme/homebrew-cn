class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://ghfast.top/https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.2.7.tar.gz"
  sha256 "934d813572f28687441db42dfaf49449851167879ff5ec4a4325bd5ddd280b21"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "408bf9e634ab8a3c03db888e798bac5995f887310176d5a40a1c1f9c09e10ea4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1c747b1202b0035b0bdcbf98d723da618e1f17a2f93e00ef2dca0975919da41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c30990030bf7948d48e8d5e2955d9a86001a2d9f0139dd4504cf49364f007e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "03707f79729976baab75b247c09036aa9a76918a47b6829ba65aef253c667cfa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea6545fdacbc2fc1e495b7c6221ed50b4f3d305df9a3cd9353d8490101da058f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0c478dfa6b39b7b1859cfad2651808024234db78a00dca11b5e6519dc32ddb5"
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