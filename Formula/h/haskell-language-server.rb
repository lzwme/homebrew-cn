class HaskellLanguageServer < Formula
  desc "Integration point for ghcide and haskell-ide-engine. One IDE to rule them all"
  homepage "https:github.comhaskellhaskell-language-server"
  url "https:github.comhaskellhaskell-language-serverarchiverefstags2.8.0.0.tar.gz"
  sha256 "af6c76d21d577c2712ed7106d8ba00ec734c9285de58293f78e1cc1cc203d154"
  license "Apache-2.0"
  revision 1
  head "https:github.comhaskellhaskell-language-server.git", branch: "master"

  # we need :github_latest here because otherwise
  # livecheck picks up spurious non-release tags
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "97f18e33ec1094435f890c03ebeecda4caaaee0b18d06ea32102be43e8ea4cce"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a64099f8dc9bffef9e95ff477745f0330aa561591f9e2cacdbd0789a6a28289d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d1c4e2a511ffba766a4770a499133eb85592b44beb36bd10cb5e3fa4ddf00af"
    sha256 cellar: :any_skip_relocation, sonoma:         "986b55e3f0674228d1b6148525f354fe780ec5d69082a619d6a8795677448aa5"
    sha256 cellar: :any_skip_relocation, ventura:        "6c97b66ae29e48f6bae313a496a15a9f69b2c61c1e2ac394b8d45bad1634fa8c"
    sha256 cellar: :any_skip_relocation, monterey:       "1470930b0cd2e62edc86fe4e2f514432ab53f06b03fdb1e5d43f434d6c1c931b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4954a468414a4096ae9ceae894bb532571518c417ccfcc90aa5becfdf2212ee"
  end

  depends_on "cabal-install" => [:build, :test]
  depends_on "ghc" => [:build, :test]
  depends_on "ghc@9.4" => [:build, :test]
  depends_on "ghc@9.6" => [:build, :test]

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def ghcs
    deps.map(&:to_formula)
        .select { |f| f.name.match? "ghc" }
        .sort_by(&:version)
  end

  def install
    system "cabal", "v2-update"

    ghcs.each do |ghc|
      system "cabal", "v2-install", "--with-compiler=#{ghc.bin}ghc", "--flags=-dynamic", *std_cabal_v2_args

      hls = "haskell-language-server"
      bin.install binhls => "#{hls}-#{ghc.version}"
      bin.install_symlink "#{hls}-#{ghc.version}" => "#{hls}-#{ghc.version.major_minor}"
      (bin"#{hls}-wrapper").unlink if ghc != ghcs.last
    end
  end

  def caveats
    ghc_versions = ghcs.map { |ghc| ghc.version.to_s }.join(", ")

    <<~EOS
      #{name} is built for GHC versions #{ghc_versions}.
      You need to provide your own GHC or install one with
        brew install #{ghcs.last}
    EOS
  end

  test do
    valid_hs = testpath"valid.hs"
    valid_hs.write <<~EOS
      f :: Int -> Int
      f x = x + 1
    EOS

    invalid_hs = testpath"invalid.hs"
    invalid_hs.write <<~EOS
      f :: Int -> Int
    EOS

    ghcs.each do |ghc|
      with_env(PATH: "#{ghc.bin}:#{ENV["PATH"]}") do
        assert_match "Completed (1 file worked, 1 file failed)",
          shell_output("#{bin}haskell-language-server-#{ghc.version.major_minor} #{testpath}*.hs 2>&1", 1)
      end
    end
  end
end