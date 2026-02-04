class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.1.11.tar.gz"
  sha256 "b64bca255266b012e6f83ccd0ad747747fd60f5ba5032d84dc70cd12dacde501"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "08efec85087f526be90480faf9a72b2092930599869db579bac75750ae18f977"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa674070b36abc5e668f3dbd4f520f76aa27d4d1f5418c66199de073f06044b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f84f7388fc589a96ec0f49fc98f9b626e99fc617641eb21b93bf85526a38a54"
    sha256 cellar: :any_skip_relocation, sonoma:        "5bf08fe69927129766a92be2a82a4d663dcc2bcf6afd56f7e6c5431152f1f5bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf7a40f244aa3b971249cf0fa75ec0644f610531de0bc36f11f6cfdc017a2aaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "351aa4ac26bd9c97aa3f766e837524276703a8d2262f8f392c9289131bf699d2"
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