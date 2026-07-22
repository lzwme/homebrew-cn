class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.2.39.tar.gz"
  sha256 "34791c687b2c9fde08125a6de4b748ea7dfb1765a9984179ac711d895bf72d8d"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dbdd68c0c00e2d567b6c5a8ab997001798e70008653d6b08c3fdea9d23dabbb4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51fc0badf9590a7e27162c6d691dcd7e774fe54c4703a19af4033a98bd585bcd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0712bec8ef5da0c3dbcc58869ba5558b7a3b46568617578c018f4d6c84137427"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e9dfa9cbd5037e6d03320512ef586aea5c257ac781ae42f30a79e5f675bd156"
    sha256 cellar: :any,                 arm64_linux:   "93fb11737309f6779bfd1ed545146bb084e566667e0d641df20cbf754c3cb574"
    sha256 cellar: :any,                 x86_64_linux:  "3ac93819e3f7cb9f391d3040c488236c842b8e1033e813c89e99efd601da8aa1"
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