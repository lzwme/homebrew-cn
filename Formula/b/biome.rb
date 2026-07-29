class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://ghfast.top/https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.5.6.tar.gz"
  sha256 "fed6432c5e5f4854996b91d2d7cd3495505ac48c5f7c15b294082c5ab9f1d2ec"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "93cc57e8fc4f1b7f47c312b19178c80f7428c16eb05877f3faa075800f6a9a17"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6b8f6a1f03ba41f6a10f0db276537ef6642ff2c2a0ecfc43c20f9816a106a8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "256b00caf61cd8442d77282f36753b4ce2034a337a9bc82a118e4cc853533235"
    sha256 cellar: :any_skip_relocation, sonoma:        "49147c18dd41c3d16e2c6d033eb6b6e4456d913ac4f098b1d8816c230e4c4088"
    sha256 cellar: :any,                 arm64_linux:   "007ee7c7ceb59bdfe431efe6ae434312d415a72b46125de86f62a505d10c727e"
    sha256 cellar: :any,                 x86_64_linux:  "87ced3537ca2c83538a66167fca1d2b7f8fb419dc126b4605e6aa7982fd5454d"
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