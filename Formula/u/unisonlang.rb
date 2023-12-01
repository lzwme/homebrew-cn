require "language/node"

class Unisonlang < Formula
  desc "Friendly programming language from the future"
  homepage "https://unison-lang.org/"
  url "https://github.com/unisonweb/unison.git",
      tag:      "release/M5i",
      revision: "4ffbc7ee69ec10fdd093a2ad9aaad16af75f2ca1"
  version "M5i"
  license "MIT"
  head "https://github.com/unisonweb/unison.git", branch: "trunk"

  livecheck do
    url :stable
    regex(%r{^release/(M\d+[a-z]*)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0b9fe64aab3d82611fdca2ca993ecff7972786d87a821f841dc3865de7c6f7b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0da230b4a7105735597ec11f58d666eda033f6f087aec109d0989fd9fb367917"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79c0a67fda5b87670bc4030fbfa9edac6ac923ca24bad6ddb1444eeb090024c2"
    sha256 cellar: :any_skip_relocation, sonoma:         "9fe4b29ea28a2f2777dfdc7c996f245c31e14b6bf9013f1c8c8daa61d684951c"
    sha256 cellar: :any_skip_relocation, ventura:        "69a3d3e8fc286e287caf9d9a886900f9e933357f2b750a88984960e1438648e5"
    sha256 cellar: :any_skip_relocation, monterey:       "d3332fa8b0ad2949787eb58f082b9f5e5e3ffb52253442764204e21cf530ed76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb5119dacf5c039bebe2d180c687e5e465d09a8265b949486c2dcfb9e4fea90b"
  end

  depends_on "ghc@9.2" => :build # GHC 9.4 PR: https://github.com/unisonweb/unison/pull/4009
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
    url "https://ghproxy.com/https://github.com/unisonweb/unison-local-ui/archive/refs/tags/release/M5i.tar.gz"
    version "M5i"
    sha256 "607c39418da9970914ec7261dc20bfb7c3f68322180f52c2d37e6c9dcef2566c"
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