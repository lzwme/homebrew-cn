class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.1.40.tar.gz"
  sha256 "3fa4dd4412a29bcca00a401313f065ede306ef4b1ba8966b457e56bec3c521f6"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40d98170b9fcf6b92587ca9a19e1a90a66ed647721bb645b520e6ff699f0ef8d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d516060cd525ce918da6149b9132d4b9feb8db4251feb709140d2400a6888c35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cda203df70c2ed8b342ba9b0d24cf3dfc5e56d8e6c8fd84505863206a8681444"
    sha256 cellar: :any_skip_relocation, sonoma:        "13eba549c7e3979c8e014d46fae46eab4dae2f7f20e0c307c1fe3062d182edec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96b26bd07bd3e4cd6dbd2275202635f68a34af79f2a54eaeb3282facef2642a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "785390df7e58da513a0beddde8c58c71ff853d5c52687877ec6d62c907b84189"
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