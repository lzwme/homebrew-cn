class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://ghfast.top/https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.4.9.tar.gz"
  sha256 "15de41c162c3fabbf08790a4b753b57a3f8b40d5474eeb450603ecc088dec104"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b75d4e6f33c477b0ba50ac96748cace14765ee8e0e051fc00a9e21c346adefe0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c82483233ee6d24790792b0f38d1711a0a5aecf24cbdf50f5dcd10ec0a23d04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "848365da52b1e73d6776417d0510c2c64e2d07285f6d79858ba4bdbe02e311e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "b581b28c39087e283f49b04ff7879d5d336b4609506a31b7fbfcd2b919163c4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c8f5779bf977f600923894e7aa1dbdd7b577ba2ef9859ec928c169822e1dc3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e2207c9d844b923df836ccc696d7fb72edf91e7f2cb8418b32e77ad4edf2671"
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