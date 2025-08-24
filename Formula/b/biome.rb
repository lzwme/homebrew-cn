class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://ghfast.top/https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.2.2.tar.gz"
  sha256 "673d7775a5b9abc86e4446a63f237ba313f1565159398888ffd2f00158dbde23"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ab6a7796bc074197b1790f57b680fe7809837a5b38c998791b31bfb24e0ec5d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eeaef0623e1449b169d7348e58bbb2ebb52eff1225d3a9c8d12e3365f881018d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ab90ecd6ede2127375623a04a3c7ec5d58cc3c5f7de3931b6175bc4ce2b1b66e"
    sha256 cellar: :any_skip_relocation, sonoma:        "87d9f2bdf6a3bea77e2021b6c86bf0099d9f1b17aadbeaaa75a5a0a959d4fea1"
    sha256 cellar: :any_skip_relocation, ventura:       "b216126f0892da598f9a8a1626a86ee77c4adee5f05b4204dfa988a54a912b4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8411868aaec4670fedd0ef768fd5fa442db678b6fb6bf04a606b3a10f86b0f8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5038e11f6f46c333890a16be44795505a7ff05b13a77f25e91c5dd09b897ccc2"
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