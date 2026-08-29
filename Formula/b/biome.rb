class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://ghfast.top/https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.5.11.tar.gz"
  sha256 "e42e795fcde6984adca5f3a27649e90500b69aa78fdfb0973caaf3a2d52eeca3"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "576b8a771a901351b175f50c95630afa7eba565b799729edf18c677aac8d2d55"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a1430470ae0b9a6fd2852c006fdf72d0a195da6a908a51234dd312f6db9d00b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4ead71ee1ed8a4719f55c90e3fa303cca2025ae84446f506ce324bd63137214"
    sha256 cellar: :any,                 arm64_linux:   "75d22c9db84c180f455607ce4292ecd62ec67de0a69b407037a79359bc380c45"
    sha256 cellar: :any,                 x86_64_linux:  "957fa15403ef25fe3757d46f3f86db12124516600a27a21f0c39c44af5587096"
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