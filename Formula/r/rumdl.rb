class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.1.80.tar.gz"
  sha256 "37c020e396f53302e887b04d37b3ddb7cc3668a71854149abdd4cb9dfd0332f5"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "41c0ba3ae7a3e6c0f935ade1a196c718bd2a4ee654fa30956074b46dfcfea2f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "328f5159b4ec6a4b790415bd0b773780b20e8a1729d30e4b3fa9b30e0aa53a68"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4fb853fbd6dc1e92bb398efeb06898365310ad7253413d10d1cff6ec5eb4dfb7"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a0e1f10927df9dd2ecafc8d7a78e020d23fe809aacb17a6ea420db2c6fad2a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1767edf5c769ad641b695efd3817a2d228391c9fdbdb957e1c703063b3dbce0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3307839164899586acd3815c8c208682d8ff068dc368f92928d375b9f0b694d3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"rumdl", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rumdl version")

    (testpath/"test-bad.md").write <<~MARKDOWN
      # Header 1
      body
    MARKDOWN
    (testpath/"test-good.md").write <<~MARKDOWN
      # Header 1

      body
    MARKDOWN

    assert_match "Success", shell_output("#{bin}/rumdl check test-good.md")
    assert_match "MD022", shell_output("#{bin}/rumdl check test-bad.md 2>&1", 1)
    assert_match "Fixed", shell_output("#{bin}/rumdl fmt test-bad.md")
    assert_equal (testpath/"test-good.md").read, (testpath/"test-bad.md").read
  end
end