class Unisonlang < Formula
  desc "Friendly programming language from the future"
  homepage "https:unison-lang.org"
  license "MIT"

  stable do
    url "https:github.comunisonwebunison.git",
        tag:      "release0.5.29",
        revision: "99baffd3b436d9d87254f8dbdf13a479fc63f4e3"

    resource "local-ui" do
      url "https:github.comunisonwebunison-local-uiarchiverefstagsrelease0.5.29.tar.gz"
      sha256 "1e6c2b1f299495159f15113b669bfeb13bb53bf68205203e4a30f82c2f434fe4"
    end
  end

  livecheck do
    url :stable
    regex(%r{^releasev?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec0f527e2f8b0968ed9fa43d2fc91ea814336329cdd8be8c740acfd920920a88"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d79afed87c658a5f72c88e83f2f38e4a5faeb81cd2733d2aa3f81faecf55693"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fdc2e69d6f23e13e168a10b307f03b45e73aefb17f0772acd32e71a4417005ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "0718ad8212c9629c9bb528f19b68d1dd8ae9376e35f3e0530349c68f360d0ea6"
    sha256 cellar: :any_skip_relocation, ventura:       "a4848fb4df607fbc4b86f846ceb017aef0deaa0d96e380d9eea4381488275dad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48db1414d3f46c92a48d4d194e94ded51a69b2506744c8f8f592a834c29d6378"
  end

  head do
    url "https:github.comunisonwebunison.git", branch: "trunk"

    resource "local-ui" do
      url "https:github.comunisonwebunison-local-ui.git", branch: "main"
    end
  end

  depends_on "elm" => :build
  depends_on "ghc@9.6" => :build
  depends_on "haskell-stack" => :build
  depends_on "node@20" => :build

  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build
  uses_from_macos "zlib"

  on_linux do
    depends_on "ncurses"
  end

  def install
    odie "local-ui resource needs to be updated" if build.stable? && version != resource("local-ui").version

    jobs = ENV.make_jobs
    ENV.deparallelize

    # Build and install the web interface
    resource("local-ui").stage do
      system "npm", "install", *std_npm_args(prefix: false)
      # Replace pre-built x86_64 elm binary
      elm = Pathname("node_moduleselmbinelm")
      elm.unlink
      elm.parent.install_symlink Formula["elm"].opt_bin"elm"
      # HACK: Flaky command occasionally stalls build indefinitely so we force fail
      # if that occurs. Problem seems to happening while running `elm-json install`.
      # Issue ref: https:github.comzwiliaselm-jsonissues50
      Timeout.timeout(300) do
        system "npm", "run", "ui-core-install"
      end
      system "npm", "run", "build"

      prefix.install "distunisonLocal" => "ui"
    end

    stack_args = %W[
      -v
      --system-ghc
      --no-install-ghc
      --skip-ghc-check
      --copy-bins
      --local-bin-path=#{buildpath}
    ]

    system "stack", "-j#{jobs}", "build", *stack_args

    prefix.install "unison" => "ucm"
    bin.install_symlink prefix"ucm"
  end

  test do
    (testpath"hello.u").write <<~UNISON
      helloTo : Text ->{IO, Exception} ()
      helloTo name =
        printLine ("Hello " ++ name)

      hello : '{IO, Exception} ()
      hello _ =
        helloTo "Homebrew"
    UNISON

    (testpath"hello.md").write <<~MARKDOWN
      ```ucm
      scratchmain> project.create test
      testmain> load hello.u
      testmain> add
      testmain> run hello
      ```
    MARKDOWN

    assert_match "Hello Homebrew", shell_output("#{bin}ucm --codebase-create . transcript.fork hello.md")
  end
end