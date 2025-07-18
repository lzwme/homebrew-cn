class Koka < Formula
  desc "Compiler for the Koka language"
  homepage "http://koka-lang.org"
  url "https://github.com/koka-lang/koka.git",
    tag:      "v3.2.0",
    revision: "1a63e4c167f7a2df5520e4fae001eed0d220e42f"
  license "Apache-2.0"
  head "https://github.com/koka-lang/koka.git", branch: "dev"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256               arm64_sequoia: "8da3a6a745e2300a30c84f2a9532f4a18acca7bfd9fb094153ef0a337713da59"
    sha256               arm64_sonoma:  "e13544bde867a2b2e188235415e89d4466a0bdafa94bec711131a4d3d2676eb8"
    sha256               arm64_ventura: "deaf384fa252e58101904528451df7381e57088103e05ffa4e29ac695982b933"
    sha256 cellar: :any, sonoma:        "71a216d34cd100eed6fc9f9df48b7edc6f30b2e00c30fb4e4edc89b5faf189b3"
    sha256 cellar: :any, ventura:       "0cea081abc53060ec6c7be7e88e741d90563e7c1d4f3e92cdd0c8899ffd88202"
    sha256               x86_64_linux:  "427693e8cd53d267a8b8a3d76020b248974227c47efab0cf73503b6123e06f91"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pcre2" => :build
  depends_on "gmp"

  uses_from_macos "libffi"

  def install
    inreplace "src/Compile/Options.hs" do |s|
      s.gsub! '["/usr/local/lib"', "[\"#{HOMEBREW_PREFIX}/lib\""
      s.gsub! '"-march=haswell"', "\"-march=#{ENV.effective_arch}\"" if Hardware::CPU.intel? && build.bottle?
    end

    system "cabal", "v2-update"
    system "cabal", "v2-build", *std_cabal_v2_args.reject { |s| s["install"] }
    system "cabal", "v2-run", "koka", "--",
           "-e", "util/bundle.kk", "--",
           "--prefix=#{prefix}", "--install", "--system-ghc"
  end

  test do
    (testpath/"hellobrew.kk").write('pub fun main() println("Hello Homebrew")')
    assert_match "Hello Homebrew", shell_output("#{bin}/koka -e hellobrew.kk")
    assert_match "420000", shell_output("#{bin}/koka -O2 -e samples/basic/rbtree")
  end
end