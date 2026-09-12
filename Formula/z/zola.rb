class Zola < Formula
  desc "Fast static site generator in a single binary with everything built-in"
  homepage "https://www.getzola.org/"
  url "https://ghfast.top/https://github.com/getzola/zola/archive/refs/tags/v0.23.5.tar.gz"
  sha256 "3a41eeb41d4ad78ec67dc6636148e5c8be25d789b902439479b992f67e055c06"
  license "EUPL-1.2"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "fa457c238ace132b50add8088f4cb278490302ba0c38a1e144192f4275b55e0d"
    sha256 cellar: :any, arm64_tahoe:       "257b14d4d337b9af0eeb85ed97f81cdcdec89487b6122b3974431b08d1dfee35"
    sha256 cellar: :any, arm64_sequoia:     "465f79555760b5147d3b699eb40c7b5f25120c8786cb0adc81b4ab56b7ad0571"
    sha256 cellar: :any, arm64_linux:       "84c835fd6969cf6bf0df82f96c4e87f3bc4665ec81280de27ea78c10c109feec"
    sha256 cellar: :any, x86_64_linux:      "72df4ba5ec27aa96723a8462c4b817702dd91d9482a1d510dee8403fb7c1cc52"
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