class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.0.214.tar.gz"
  sha256 "b491aa38d5e77df4bd3cf36cf87b4218b84a6bfd86bba89a5d049dd43563d52a"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e1b6ced2615f78396e5936bda358829b77df3f53ed55eb7ad0196da02c0870bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "faf8c84d7829d3a21f5b355ca46d06e766cc6f573a5e4abaf9719d0d5c7344fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91fe87d5ae7cad3b735152c23772a0575f3d4fad72f06f2d8422e227822bbd85"
    sha256 cellar: :any_skip_relocation, sonoma:        "193c342bfcd2d510c001910ddfd9a9f6f255c15d109f388a98e9701645a8aa29"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15a768f07dd6590c777d38cc0314bfc366c356f6e53a98e2454815bd97870f16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3163d5e04d87b6c45a1f6088ca03b39eafa73e6ef7437a3fce5808fac6857448"
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