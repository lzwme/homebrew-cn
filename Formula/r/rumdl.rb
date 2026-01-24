class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "efb1d5682689a2c1eb23ce6191cc87d10f34c903031299a3e7e036c4a2034e07"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2932d5dca5130670b6463d671ee95915fab9649d59212837a873f6724a97605"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0becceb09d6299204658f89b5bfb9064f2021a10895e9686c6a6ecf613647ede"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78acdaba94939b387edcd48a5eb78bc36e704f9d0e32ddd3490d83fdc808647c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9025ca0c3b7f7455df95b0c1620ded89ba4b070dbf11bb3c076911d0d7558a93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b406e43fd5b55960cee3613aa285d73dbca0f9b49f9f7c990fb9189f875e10b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9be9c7f08384be67072f8edafbe3cefffed176268515e04283f7c395cc9d1d5e"
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