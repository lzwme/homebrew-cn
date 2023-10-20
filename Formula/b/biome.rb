class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://ghproxy.com/https://github.com/biomejs/biome/archive/refs/tags/cli/v1.3.0.tar.gz"
  sha256 "ea41876c473012e62e0cf674f5583c0fd832147a772cad4aa691a29dea3212ad"
  license "MIT"
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dcc0f225e3b94159f6c1f45fc4a76bf29e10444562e16eadd03dd6fc079713ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd397f11e79ad24a9ac73b8a4029ccae6956994045fdd67e1aebda8a3413f83b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10edd48f0b59722ca86bcd435990f28b898fbf4bd24ac644a8f46518fa434d2c"
    sha256 cellar: :any_skip_relocation, sonoma:         "ca85277b623ffd04d6b6d9f5334d88baf3e45fed7d814041c7dbea119146f1ad"
    sha256 cellar: :any_skip_relocation, ventura:        "b2741ef7849aeafd482f9d50269cc84a8527c99d428cd3c2a7090e1f3c366bde"
    sha256 cellar: :any_skip_relocation, monterey:       "19da351cddcaefcb85db00f7afe262cee258f4fc1a1535834e38523f21df43a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e29f3cbb47407b8af751a136482ae5b7f8afc1259ef0da700d1a9270907db67a"
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