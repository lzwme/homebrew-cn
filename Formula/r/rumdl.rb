class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.0.183.tar.gz"
  sha256 "c33302b928da5e882db23a757d95a2527221f5c85a9040202f96f9417c468b3b"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1952545ae1d798b11fafcd9188b04e76ef0c959ca4a8cb650481f66f63fae20d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "408295bbd04bcab31187ce10a42e6b359ca1404993bbea2b4849147befe3e982"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e70cb0d4d07ac0464f147f6c6fd484dcd59ad08966aa16594dd0f2fd541abe5"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c07349e97a96ba9b531c39e067bf732aebf7a6237e76bcd92daf32ae3696a8e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18f664be5330a5320e25fc7faa651e6fc8ccf7135a6b7bc2a664f9d2ac7e774b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1698d6bcb9c552aed0153d724fd8f27e362c5b7481d6e3c13803c750432fe105"
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