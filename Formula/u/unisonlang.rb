require "language/node"

class Unisonlang < Formula
  desc "Friendly programming language from the future"
  homepage "https://unison-lang.org/"
  url "https://github.com/unisonweb/unison.git",
      tag:      "release/M5e",
      revision: "0657e4af76043cc5501877249f6594e2aac15d05"
  version "M5e"
  license "MIT"
  head "https://github.com/unisonweb/unison.git", branch: "trunk"

  livecheck do
    url :stable
    regex(%r{^release/(M\d+[a-z]*)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97380203730c706c7533dc315a8ab73fd50bb11cce4fa55cc479b5d63dfe810c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d4a227c33640cf22a2f8c683875919ccd1cd349bd8f31c42da2f18220edc1804"
    sha256 cellar: :any_skip_relocation, ventura:        "4cfb5840f973dd6e82331bdee04c978c11e473bf8a8b5435e3fa27a5b9f0db4b"
    sha256 cellar: :any_skip_relocation, monterey:       "9fb9b19dd7c480d4c69a6246445d85a82f1a19fe5a9c69d47a54150cd0051b7c"
    sha256 cellar: :any_skip_relocation, big_sur:        "82283403d8fe36ae698cb23bfb4aa989159520c14ce0bfd7be0b82c8da235dda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bdaa3d2981530eb7526deed9210733f7e482a473fe65d4647d42af9a3ef36910"
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
    url "https://ghproxy.com/https://github.com/unisonweb/unison-local-ui/archive/refs/tags/release/M5e.tar.gz"
    version "M5e"
    sha256 "dbc90295d0511296fe20e34bba6f1a384f0059e22895d0280855f5514e88d630"
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