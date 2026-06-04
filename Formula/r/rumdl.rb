class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.2.7.tar.gz"
  sha256 "d04fd9e9e119cd7ad631d6d082d7eaa88fa9e31b4264869faf75a53e6473bc8a"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f6114fe018c3d1f191feec8704222160d926736d507b8c05d1fd1cdb677d710"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83774f117df94320b20b769d975327e4fddf8111b35fe36d4de94c0af3106353"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6930db68d965bd925836f0f69b0c96139f489f9cfb235a8c05b18bcf652a1b68"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa92fb3bdbf12456ddd3266e95c0a3b91e97de5d9cb5510900936d8e76607b46"
    sha256 cellar: :any,                 arm64_linux:   "f3ab0a9b5c91890ed8dfba140eb5fc5607c5252830be7d416c9c431136cd3386"
    sha256 cellar: :any,                 x86_64_linux:  "a252633ce5939cd5729cf713e3a900d29c8dc908ae65cc6cf8ccac21b55ba71a"
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