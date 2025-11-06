class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://ghfast.top/https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.3.4.tar.gz"
  sha256 "33380b1dc507b3b4366a26b8c75f9a4d51a5c761975698e34c2378103e981be2"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e9706fd9e2b3ef9e9334c27ea1741272c20f6b3d3b9fed16cd8ac476fc32966"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f7785255bc3a313758c213a913a6c979e648c5ec92acb6ec6e79bb631f64241"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0031f8db9d8fe8c639669c909aab81b291013c2f8266ded1003127bac891bfe8"
    sha256 cellar: :any_skip_relocation, sonoma:        "930ca49f9724250948fbd5e3082e70b12c15c7798029fdbd8c5933a526056452"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb35190f29661591f43fbac988e05d16d5486b0956c7500e22dc1cbbcb7d4e51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a608a05e3d91bb8903c88e50e5d82fb79c481b7931ed687d508d5d73fe8f9c68"
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