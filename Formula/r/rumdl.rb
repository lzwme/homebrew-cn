class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.0.202.tar.gz"
  sha256 "acf0a32b5907b1aa8a0bad598189aaa69f3cbbc42fc5520f5124aaa9f7099acf"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f1d144620f01afba23f1b5cd27dfcb44c7895ee2749daea1181dd109cf847d6d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53bcdaa0f32ee41da4cbd02c11931a344a485e528e25488f01f6df11cf5ce1e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23abaad3dfb31c12e6040409caa72860570a11d1af029960f4be980d7be18b05"
    sha256 cellar: :any_skip_relocation, sonoma:        "55c1d7d62e704c9d3759426664bdabfa7cfb77f7d1507f48d482702a4db1c718"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7b7882f6b6b527d14060e19fcd9ff7b2dbfd7c51e7bb28a76b5a3ead467e7ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b615cc375d34fe91235fcd48708404f2ce96f3a49caef3368a4983fce0def65"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
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