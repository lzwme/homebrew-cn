class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://ghfast.top/https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.4.0.tar.gz"
  sha256 "0810327e92519f686f3a3811870fb5bdaad328fd605dda19a4bef3b994acba9f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "90563fb9eb60e57d1a29d9e7e72296675e9ae9f1d5241abbd1b2a1f0375b4be0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b99f4c3f6e739af506956bdb074542709d36458f25e20cacb74884cccef10a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2abe8cadf836c1e04fe5343d033b48808065c86d1cd30d21a9078cf09b559d66"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f28388c53ce9f7ca51ce2daf01b62b8637ec710feaeb93a4eeda00b8ac7c4f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f068fb2132466a8ad8dc165cccc69e1df85d978db7c03b40bb54759eeb523b8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8715894cbeef7b9856362f11a63efe12537bcb4e5bff00181d5c0e43733e571"
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