class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://ghfast.top/https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.3.0.tar.gz"
  sha256 "8415b17b218c514a9993b6d4c66d6186e047c55b7a786a5443e2bca9dff04fed"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7ff6df8bcd76e8e7dd55a76c5d19acccbebf575355ca8c1849c8f2e6c99e858"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f5c6370a11a5b9f7530fb9f79cba3bddfba2a4c9de993fef94ce66652f5284f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "246d144d69a6651b0096d0635060b3f681a6f279367418a08cfbcb3d03e0426e"
    sha256 cellar: :any_skip_relocation, sonoma:        "87ba656b5d7ea6134f5ca01e44897b42e6fdae8832c8696a6c459dbabedbfdcf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "864c40dfaad76c0713e55e8cd056f4d8dee12783314c659b92d4a957859f4aee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "feae1158f1aa7396206d3d30d22b4548a92c8a1661f9656d47969b0896d5054c"
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