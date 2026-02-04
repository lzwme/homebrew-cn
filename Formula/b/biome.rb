class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://ghfast.top/https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.3.14.tar.gz"
  sha256 "95fd3d9e89d9a8496e47a763906e7ad5025231391a163d0ddf974ef5e9d23647"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "36f8838028b682361372c86090377dd58924918a292d583700328d730f5fc577"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ef4a6fda07e8d4c9e4770ddae219799088ad02e1f505f5817dd56f94d5df476"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5bd3553d6750d7dfaf24f5279006807fed5db80b706045d77eed99dd7b369138"
    sha256 cellar: :any_skip_relocation, sonoma:        "314b78eac7995a897b2246ccea84ebf7dff73afb6cc0e2709e96e0995ee6215a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eaa91fd746721a586ddcf8c3843b31c0caba4d2b7289b4446bd585d1e0a7ce47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebc59219334ccc00f426fb22ed6dd55d444dfbe4327a8360214fe26971112319"
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