class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "b626eeee1d2df18b563f7f3bd72a7b62d063b7c719085c637ed61824875563e7"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70c32bb88316e687cec70cde2d4661a1523c4298c7c0728aff3da040521e53ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e46da4fdedb63e083b2ea614c295b6a75bb1a635e88bd06b30c393d45848c4cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "112d8646d766b5b8cffc6ed1332e35ef299862fc0bc4a4f8b33e3c36f30510dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6a0a85035302ff27727fc42bc66ce9a145a9b2e1fea5cd75033390f49b73588"
    sha256 cellar: :any,                 arm64_linux:   "a70ae41727ce18867ae442bf4371ff3b1fbe3091251f1b273872f30ef4713adb"
    sha256 cellar: :any,                 x86_64_linux:  "dd45954dab506cdb63febd90491fe72181c8f6ee62e48c92fbf11a13be756db2"
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