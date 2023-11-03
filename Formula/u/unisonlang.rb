require "language/node"

class Unisonlang < Formula
  desc "Friendly programming language from the future"
  homepage "https://unison-lang.org/"
  url "https://github.com/unisonweb/unison.git",
      tag:      "release/M5g",
      revision: "f761c09f7b963a3012a95465b568f96573bba185"
  version "M5g"
  license "MIT"
  head "https://github.com/unisonweb/unison.git", branch: "trunk"

  livecheck do
    url :stable
    regex(%r{^release/(M\d+[a-z]*)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e633f72a6ceedcc637644772c4e6324f0d10e71697ecfdb3360a15764313acc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c52511d1259038b72a492635ba743aa0272fa7dfc25c4bab41cca20a64e8d49"
    sha256 cellar: :any_skip_relocation, ventura:        "e99e06d2d331fc2a943024d029a303893d05b55b3d7e2e5b1bee7c617a4ee9fd"
    sha256 cellar: :any_skip_relocation, monterey:       "c221cf81c38451ee32338bd4630475ceb00d68c97a90d278eb02797b8d177d5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1370f281557abd31d49c08502aa63ff3050192994510f2fbe9b44d00fe9448ff"
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
    url "https://ghproxy.com/https://github.com/unisonweb/unison-local-ui/archive/refs/tags/release/M5g.tar.gz"
    version "M5g"
    sha256 "534b599119ca5d84836912e6965dc2b9bd53bc3ee875d3219a4a184fcaa62248"
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