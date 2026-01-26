class Hindent < Formula
  desc "Haskell pretty printer"
  homepage "https://github.com/mihaimaruseac/hindent"
  url "https://ghfast.top/https://github.com/mihaimaruseac/hindent/archive/refs/tags/v6.3.0.tar.gz"
  sha256 "2726bdbf137691624997f181c29392f22f8566ebc87c5f82e420adfb0068ef07"
  license "BSD-3-Clause"
  head "https://github.com/mihaimaruseac/hindent.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b3d7317ba8d50474ca4075b3a1964fcf3f97b24faf92b1543a63b88e19342ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d7ff8ab144f02b3faa551d69a7b0ec12904d564a1680db14095210a7136438c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "331c7d1a2c52920aab79d21e878e11ce0fda1304ae0780bc3795a1bbb7c5b73d"
    sha256 cellar: :any_skip_relocation, sonoma:        "586852757b86870cdfe2fee14837c91d802db6e80f747d8c1d7f45749abc38ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "968afdac71bf20e80f9948914eed5b02522ea376de2e271631baad0103c92905"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c90b935923f54e30d49278ca6d4da909fda5db261a57886764b3829f8fa52231"
  end

  depends_on "cabal-install" => :build
  # TODO: switch to ghc@9.12 in the next release
  # https://github.com/mihaimaruseac/hindent/pull/1000
  # See GHC 9.14 issue: https://github.com/mihaimaruseac/hindent/issues/1155
  depends_on "ghc@9.10" => :build

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hindent --version")

    (testpath/"Input.hs").write <<~HASKELL
      example = case x of Just _ -> "Foo"
    HASKELL
    (testpath/"Expected.hs").write <<~HASKELL
      example =
        case x of
          Just _ -> "Foo"
    HASKELL

    assert_equal (testpath/"Expected.hs").read,
      pipe_output("#{bin}/hindent --indent-size 2", (testpath/"Input.hs").read, 0)
  end
end