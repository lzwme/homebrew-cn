class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.1.61.tar.gz"
  sha256 "d7d6e707c7a933887cc95b404a44b24f9ee1e37b787128a5d500c565ea724053"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc45d6e0331ee290ae063810addcf545a531940e40507d90101a5c557c65b1ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0d7bf7bf7185ad01f569121d44ef22d27a96fee0e7af8ed5bb55b79ea64e37a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a57d39ec4a196fcd0d952bc3a36c8d9e34f69a066642f0e254e7b79d64a7f4e"
    sha256 cellar: :any_skip_relocation, sonoma:        "cec22be7461eb9fb47d7db194b9f4e180d1372ead816080031415ed423ee17dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4988904eefe5f5cea11f837934af152dc3eaf44bb33e0ddabd9cb753a9b0881e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc8035365565fa2e277f7977fd268fc25b6cda61496ac4e41234b3984c46bdaa"
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