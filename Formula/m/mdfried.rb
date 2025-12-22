class Mdfried < Formula
  desc "Terminal markdown viewer"
  homepage "https://github.com/benjajaja/mdfried"
  url "https://ghfast.top/https://github.com/benjajaja/mdfried/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "df952d107084445e6b6eb1f0b5247ca521f771e3663fc02def812b91a5bdac1e"
  license "GPL-3.0-or-later"
  head "https://github.com/benjajaja/mdfried.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "211c81d901d04a86791c4ae2f96e6ccf32205b7cd6e5c3f4cb71a08ab7116906"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e311a7a035061229f080ab415234d227f24f47bafd97372b03141a1e94af1721"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "138b5f131dcfce5a9f9eea464f9ef23a7f69d3a7eff178bf67219d4451cfd7fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "5739f5a706bdd2617ff5d01ccb1afc35cd2509568fccf9a0842c4412ee31c76a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "225c181705509ec9a3162c71e3aa484245c5cd420d30fef816eaae7cdacc3346"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83d531b1d097be17b60d7adf9b844e443920c39fbe271e8bc1b8bb1fc3510928"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdfried --version")

    # IO error: `No such device or address (os error 6)`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    (testpath/"test.md").write <<~MARKDOWN
      # Hello World
    MARKDOWN

    output = shell_output("#{bin}/mdfried #{testpath}/test.md 2>&1")
    assert_match "cursor position could not be read", output
  end
end