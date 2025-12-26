class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://ghfast.top/https://github.com/rvben/rumdl/archive/refs/tags/v0.0.203.tar.gz"
  sha256 "eb0e7e196730d576bd62dee0144ebabb3a0eb180c93a65e2b6cba42653fa534f"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "114069f82a4706175807beea037cc13123574ac3a765d9161115186fa86d8b91"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "622b20e837fdd95ccb364b84403935defd558ec64dd29cdf60c680b352ac915f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c2fda47937a1a691df18f90054012daf0fa8308f7d4c49cd34eedaa703390e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "e856be83c09ac65c02e0973665d05ed7b2793fdc38274745109d8a695c8d4104"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6bd56926fce111dfb9a711abd853619d39b2fbe0ee6b1d0787b712c11d88b0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43e71d63765e8f02eadc9ea26b1c60e1748efea569f4e3ba3e2f822a7edf23c0"
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