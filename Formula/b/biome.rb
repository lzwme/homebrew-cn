class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://ghproxy.com/https://github.com/biomejs/biome/archive/refs/tags/cli/v1.4.0.tar.gz"
  sha256 "3c2b431b39cafbf35646cc6d1b39ae3db9a8c8b399a4444b451a9cc1a98805d7"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2eae416214345738612396b00c5d4fded25e428d1a21aa0d1c3f145618b3e41a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5417b62cb304b79065f41ce718707d4f546ceb0699f8c1112053b12580dff306"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "92e8ac026cce9d41afcb37d855a6d619adaad04f25b799c3a94546a18c1ae5d8"
    sha256 cellar: :any_skip_relocation, sonoma:         "9694479a8a15a760b101daa0f642e404252166340e7b55d2b02b8cf417b225b2"
    sha256 cellar: :any_skip_relocation, ventura:        "6436bdf36b90c00473dcfc2718cdb1316f78a7858e5ecb25b992b65c2364abeb"
    sha256 cellar: :any_skip_relocation, monterey:       "31fa43a05e567f60f5e7ce7ea8d9feda73a13423f2b94ce81661b5b46d6f38a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd6325bfe10179c48fa470fd5f475e0e4d56d4c5a7e1e1c5443a119eda5cd2ba"
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