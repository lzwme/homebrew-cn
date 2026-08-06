class Zola < Formula
  desc "Fast static site generator in a single binary with everything built-in"
  homepage "https://www.getzola.org/"
  url "https://ghfast.top/https://github.com/getzola/zola/archive/refs/tags/v0.23.1.tar.gz"
  sha256 "331240b037bbef0a15e6c1db5a2eb572097f12a362deb075a331dbb849928f83"
  license "EUPL-1.2"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "158da3d8fe572f538d2026b22e1f9c6354e3f61d0e69831108372cbd9d285ebd"
    sha256 cellar: :any, arm64_sequoia: "a478227686bc445ed2fa4ace4ec984d62a4a8f55c02f8e015e303ea03dee399d"
    sha256 cellar: :any, arm64_sonoma:  "aa67b90ff613f742d306204fe18a42d6f407fa6b515e8d5b33d621a2f9f7409b"
    sha256 cellar: :any, sonoma:        "5c25eb728fee90ec1abbacb6d6dad77a6b8d33673e5e1c3e1c896ee48f14b202"
    sha256 cellar: :any, arm64_linux:   "0a6711fd850295277ab57ce26886c543ce7abc29a10e42fe59bf2b2174862336"
    sha256 cellar: :any, x86_64_linux:  "3acbc3b0d5ac2043a2affed5cad27bdf4c567b46e5832d45dba9daff2f8e6356"
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