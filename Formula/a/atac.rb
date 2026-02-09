class Atac < Formula
  desc "Simple API client (Postman-like) in your terminal"
  homepage "https://atac.julien-cpsn.com/"
  url "https://ghfast.top/https://github.com/Julien-cpsn/ATAC/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "79a5171a0af3ac99086d6e02d542b0c6330600517f1460cd291d2edbe331b461"
  license "MIT"
  head "https://github.com/Julien-cpsn/ATAC.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "efa5e2be15d8ee3f2d6f677267375abbd3be62067e067fbc8dd2f6ab2fe3c342"
    sha256 cellar: :any,                 arm64_sequoia: "7c06ad44672bd67324298504ba4bf44b971a9d6eb9cba7a5a6fc8916803bb522"
    sha256 cellar: :any,                 arm64_sonoma:  "2accdba3ec2bee0cb7add99548b992bc7d18556eaab5987030f4cba0040c3d7c"
    sha256 cellar: :any,                 sonoma:        "454e8aaf3e055aed81dd62ab2a7ce21bd8b8a2fc5825549b04c6c04eddd45efb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63530d1d597ea21baf311c4a9fd5fe723c07687965ec467f3ad3eea2928bc6bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d483e8d459ebe29d6e541e43ae4a2532ac8867c7c51c362bddb9c0eb5d4acc3"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "oniguruma"

  def install
    ENV["RUSTONIG_DYNAMIC_LIBONIG"] = "1"
    ENV["RUSTONIG_SYSTEM_LIBONIG"] = "1"

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"atac", "completions")

    system bin/"atac", "man"
    man1.install "atac.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/atac --version")

    system bin/"atac", "collection", "new", "test"
    assert_match "test", shell_output("#{bin}/atac collection list")

    system bin/"atac", "try", "-u", "https://postman-echo.com/post",
                      "-m", "POST", "--duration", "--console", "--hide-content"
  end
end