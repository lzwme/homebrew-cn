class Hadolint < Formula
  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://ghfast.top/https://github.com/hadolint/hadolint/archive/refs/tags/v2.15.0.tar.gz"
  sha256 "8088f55cf6959770a9885ab8632ea306e26a02fd88981c37c32e9422cdc3ff9e"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0c8d30ecc3433769a22668c7d0b803baa7324e4f8b140110af5947e4259e05b7"
    sha256 cellar: :any, arm64_sequoia: "2b7d461364e021522b51eb11e493897120b7c6d9b5754811d0ef556165016899"
    sha256 cellar: :any, arm64_sonoma:  "89d79f223de1042e6239c182a97cf92b23edeafba70a336c6cfaa6b16a3b2a40"
    sha256 cellar: :any, sonoma:        "d89343cb696e92d6ef0a0adbf95d42d2745599d74a86267e55486f82a0faf337"
    sha256 cellar: :any, arm64_linux:   "276ccf1dfee740cacbec21f67030a5d41aa95fe5d89c9addc2739b0802a9b1ec"
    sha256 cellar: :any, x86_64_linux:  "8831467007996f632483a55ee3232b1b5e41f4d2a822998109c380426304aa89"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"
  uses_from_macos "xz"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Workaround for GHC 9.14 until hadolint allows parallel >= 3.3
    args = ["--allow-newer=base"]

    system "cabal", "v2-update"
    system "cabal", "v2-install", *args, *std_cabal_v2_args
  end

  test do
    df = testpath/"Dockerfile"
    df.write <<~DOCKERFILE
      FROM debian
    DOCKERFILE
    assert_match "DL3006", shell_output("#{bin}/hadolint #{df}", 1)
  end
end