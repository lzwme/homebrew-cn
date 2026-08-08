class Zola < Formula
  desc "Fast static site generator in a single binary with everything built-in"
  homepage "https://www.getzola.org/"
  url "https://ghfast.top/https://github.com/getzola/zola/archive/refs/tags/v0.23.2.tar.gz"
  sha256 "f46f911079913845e76f3c446eb99d3b27546a3c302a1c411c6995fef498eaff"
  license "EUPL-1.2"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8688771544b2e9ac810318ca51e4182794da5463cb1a396afbeaa2c7a99fcde3"
    sha256 cellar: :any, arm64_sequoia: "788f494f3230eafd255342858a0cbcdca73b0aecc898fc77036cad9a454b8ade"
    sha256 cellar: :any, arm64_sonoma:  "c4258e3d974aeb67c1ce0786f519a133acf058a34642626e01d205541b772169"
    sha256 cellar: :any, sonoma:        "1d2aa439f5ccaf0896b38ebb681963ff28ae1279a77c2f415e0e002b50893909"
    sha256 cellar: :any, arm64_linux:   "e32020df7423dafbc388380548d172ad4c716197b93669ea97102d7623c25b8b"
    sha256 cellar: :any, x86_64_linux:  "352d0b8372d6bfb4f9d8bdbc671193a6cddb3bf9d35e87688096412de51779fd"
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