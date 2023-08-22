require "language/node"

class Unisonlang < Formula
  desc "Friendly programming language from the future"
  homepage "https://unison-lang.org/"
  url "https://github.com/unisonweb/unison.git",
      tag:      "release/M5c",
      revision: "5e428a7701005710ac05e9bf30d1547edd8f25e9"
  version "M5c"
  license "MIT"
  head "https://github.com/unisonweb/unison.git", branch: "trunk"

  livecheck do
    url :stable
    regex(%r{^release/(M\d+[a-z]*)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e9b8981f03099f0ad52026988f0de162e36d5fa8edc72ec2d15b7427c3eb835"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b72e935ca41ef451c2edf902971ca0641e74ece6ebc6fffb0301b87521fe876e"
    sha256 cellar: :any_skip_relocation, ventura:        "03841f8c57255a83d0d715c98ce44c5d37578aee2a46afb67e4755d3e04e7478"
    sha256 cellar: :any_skip_relocation, monterey:       "7a95df6e28095a8ed8f54067ec959290b786896a88ffb00bf2c2f9d871220168"
    sha256 cellar: :any_skip_relocation, big_sur:        "0de679779d113977c2e5cc0eb9aa8c4e8a976e7bed10979afa529012b8cb5deb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5876e2238bafed8133771462e1365caa8ecad3bc15aa81939e95ce072df9baba"
  end

  depends_on "ghc@9.2" => :build
  depends_on "haskell-stack" => :build
  depends_on "node@18" => :build

  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build
  uses_from_macos "zlib"

  on_linux do
    depends_on "ncurses"
  end

  on_arm do
    depends_on "elm" => :build
  end

  resource "local-ui" do
    url "https://ghproxy.com/https://github.com/unisonweb/unison-local-ui/archive/refs/tags/release/M5c.tar.gz"
    version "M5c"
    sha256 "efcb1fa73d37da47cc7145d5923c2a2077bdc5f9863db0673c1a694eac544694"
  end

  def install
    jobs = ENV.make_jobs
    ENV.deparallelize

    # Build and install the web interface
    resource("local-ui").stage do
      system "npm", "install", *Language::Node.local_npm_install_args
      if Hardware::CPU.arm?
        # Replace x86_64 elm binary to avoid dependency on Rosetta
        elm = Pathname("node_modules/elm/bin/elm")
        elm.unlink
        elm.parent.install_symlink Formula["elm"].opt_bin/"elm"
      end
      # HACK: Flaky command occasionally stalls build indefinitely so we force fail
      # if that occurs. Problem seems to happening while running `elm-json install`.
      # Issue ref: https://github.com/zwilias/elm-json/issues/50
      Timeout.timeout(300) do
        system "npm", "run", "ui-core-install"
      end
      system "npm", "run", "build"

      prefix.install "dist/unisonLocal" => "ui"
    end

    stack_args = [
      "-v",
      "--system-ghc",
      "--no-install-ghc",
      "--skip-ghc-check",
      "--copy-bins",
      "--local-bin-path=#{buildpath}",
    ]

    system "stack", "-j#{jobs}", "build", "--flag", "unison-parser-typechecker:optimized", *stack_args

    prefix.install "unison" => "ucm"
    bin.install_symlink prefix/"ucm"
  end

  test do
    # Ensure the local-ui version matches the ucm version
    assert_equal version, resource("local-ui").version

    (testpath/"hello.u").write <<~EOS
      helloTo : Text ->{IO, Exception} ()
      helloTo name =
        printLine ("Hello " ++ name)

      hello : '{IO, Exception} ()
      hello _ =
        helloTo "Homebrew"
    EOS

    (testpath/"hello.md").write <<~EOS
      ```ucm
      .> project.create test
      test/main> load hello.u
      test/main> add
      test/main> run hello
      ```
    EOS

    assert_match "Hello Homebrew", shell_output("#{bin}/ucm --codebase-create ./ transcript.fork hello.md")
  end
end