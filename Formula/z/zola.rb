class Zola < Formula
  desc "Fast static site generator in a single binary with everything built-in"
  homepage "https://www.getzola.org/"
  url "https://ghfast.top/https://github.com/getzola/zola/archive/refs/tags/v0.23.3.tar.gz"
  sha256 "2028bb1608b9625f78634c75b62654583fa3214fadac7e5f448a6b59b68912ec"
  license "EUPL-1.2"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d16b6db1bfcbbeb2224b561bf111f56bfb6db8f41f83a6ddce314bde8bf7320a"
    sha256 cellar: :any, arm64_sequoia: "4f2b84c21cfeb1c5466e921dbcfd8d1d3d7347b23b868fe36f57e38042e2e595"
    sha256 cellar: :any, arm64_sonoma:  "f27f850ace466bfd88b48ccfc16ae77a6aef41c289410ad5922bc201ca46c4ee"
    sha256 cellar: :any, sonoma:        "873da048852cbe5396dadc9de40a94022c90624742d58171c49ff13a6fd6616a"
    sha256 cellar: :any, arm64_linux:   "fcbe364fb93edd0c6045b27538aa952d1d1a7711961cbe1efd7b3e773ac9e5e6"
    sha256 cellar: :any, x86_64_linux:  "b395bcaf4c9dabd0227bc54f313d6577548a250c96225d810f3ec41872235f47"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "oniguruma" # for onig_sys

  on_linux do
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  def install
    ENV["RUSTONIG_SYSTEM_LIBONIG"] = "1"
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"zola", "completion")
  end

  test do
    system "yes '' | #{bin}/zola init mysite"
    (testpath/"mysite/content/blog/_index.md").write <<~MARKDOWN
      +++
      +++

      Hi I'm Homebrew.
    MARKDOWN
    (testpath/"mysite/templates/section.html").write <<~HTML
      {{ section.content | safe }}
    HTML

    cd testpath/"mysite" do
      system bin/"zola", "build"
    end

    assert_equal "<p>Hi I'm Homebrew.</p>",
      (testpath/"mysite/public/blog/index.html").read.strip
  end
end