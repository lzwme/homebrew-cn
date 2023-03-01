class Zola < Formula
  desc "Fast static site generator in a single binary with everything built-in"
  homepage "https://www.getzola.org/"
  url "https://ghproxy.com/https://github.com/getzola/zola/archive/v0.17.1.tar.gz"
  sha256 "ac58dd9d43b134d416bb29c19980bbcbbb9dd552c1ade69c72239df2128565d3"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "60769d328c7c34378175f3264b8c3caab7d30d9fc344ca815ad18083c9a5b57e"
    sha256 cellar: :any,                 arm64_monterey: "b5bf4189a6c8d5133309e124e129d41793bc2e6cd99a31f492657465812a8f39"
    sha256 cellar: :any,                 arm64_big_sur:  "8da18d40d195ca89cbe30476da97a85554bd561a1b3370140da04c553075728b"
    sha256 cellar: :any,                 ventura:        "c5641bf3c72113c4be153f220e52a1c4960d38743cc131e896f948e000be2b54"
    sha256 cellar: :any,                 monterey:       "29e6bda5f7debc7acf6bb237e789043889d7df61b757059db4bd7440533addec"
    sha256 cellar: :any,                 big_sur:        "668244d9c9d2a4e42c8fae60ba6b403894d023ef373fa6a4ecb2da8b714a5871"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4743b2841c3ec32385c31110f43f906e97ae18cece23b7a6f04ebfc53dbab17f"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "oniguruma" # for onig_sys

  on_linux do
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  def install
    ENV["RUSTONIG_SYSTEM_LIBONIG"] = "1"
    system "cargo", "install", "--features", "native-tls", *std_cargo_args

    generate_completions_from_executable(bin/"zola", "completion")
  end

  test do
    system "yes '' | #{bin}/zola init mysite"
    (testpath/"mysite/content/blog/_index.md").write <<~EOS
      +++
      +++

      Hi I'm Homebrew.
    EOS
    (testpath/"mysite/templates/section.html").write <<~EOS
      {{ section.content | safe }}
    EOS

    cd testpath/"mysite" do
      system bin/"zola", "build"
    end

    assert_equal "<p>Hi I'm Homebrew.</p>",
      (testpath/"mysite/public/blog/index.html").read.strip
  end
end