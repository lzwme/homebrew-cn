class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://ghfast.top/https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.5.8.tar.gz"
  sha256 "f380dead10231f4c2a26c16ad519553c3a4ae6a24e43faaab2cefafe41074577"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "765ff352b8f00f08b15053225ebb644149f54632e07877d0fa2462329df4aca9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6053fb828d891d47a305906c8de121f283478cdf21deb3e30f04531b95c6d5a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f7b6d015e1807a305978e0c2f5afba2bb3f9e4d76469b60d7d4d24e796b3148"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3b87096a93ddc37175f76cf5bc6ce9a9552861f77ef046b82976d27c347075c"
    sha256 cellar: :any,                 arm64_linux:   "93db9c7f9453201cb817c759eb985aa184c7f75b7e44de9baf823f7259b1a2ce"
    sha256 cellar: :any,                 x86_64_linux:  "cfaedda8edd24b934c48501b91bf76d18f03b8576f827f954f5ac02c02bba28c"
  end

  depends_on "rust" => :build

  def install
    # Work around SIGKILL on arm64 linux runner from fat LTO
    github_arm64_linux = OS.linux? && Hardware::CPU.arm? &&
                         ENV["HOMEBREW_GITHUB_ACTIONS"].present? &&
                         ENV["GITHUB_ACTIONS_HOMEBREW_SELF_HOSTED"].blank?
    ENV["CARGO_PROFILE_RELEASE_LTO"] = "thin" if github_arm64_linux
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