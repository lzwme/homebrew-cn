class Hadolint < Formula
  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://ghfast.top/https://github.com/hadolint/hadolint/archive/refs/tags/v2.13.1.tar.gz"
  sha256 "5df6d6b7c20c28588488665206259d3c9bb326d06401d5b8ce37fcfefb1a2e0e"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "405117c6327640b979c2c4291c9f59a5f1512a4d555f9abf5bc44d5f99c9daef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a93c6354f99a160ea44ada775fc16b34e32770ceb447afac3acb8b5ec5f986b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "84b76c81f67102146235bb9b96e00a70854a155b105b9008b886d7adfbb842a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "78aa3904694d312b37d4b780bed2266b52249e3a9999a8f95464f745313eb719"
    sha256 cellar: :any_skip_relocation, ventura:       "39178dccfe9a2d4252b36812a98107bec182458684b25c150021b05286b60875"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b0defde76272014be62d67a2ec25801ab2a3c3a097730977fa3963fbac6076e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "503e86593be4fde59b701ea3b8e5af67247679c7a9be60d8c83785347611f467"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.10" => :build

  uses_from_macos "xz"
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    df = testpath/"Dockerfile"
    df.write <<~DOCKERFILE
      FROM debian
    DOCKERFILE
    assert_match "DL3006", shell_output("#{bin}/hadolint #{df}", 1)
  end
end