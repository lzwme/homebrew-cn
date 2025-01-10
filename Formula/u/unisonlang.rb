class Unisonlang < Formula
  desc "Friendly programming language from the future"
  homepage "https:unison-lang.org"
  license "MIT"

  stable do
    url "https:github.comunisonwebunison.git",
        tag:      "release0.5.31",
        revision: "4324c53e83ae12ac1fdee52822356e22fa5419fb"

    resource "local-ui" do
      url "https:github.comunisonwebunison-local-uiarchiverefstagsrelease0.5.31.tar.gz"
      sha256 "f11c7101de9fe1ead9f4531e230a2d795d0789b0eab1c1afa2ca0d19c264df54"
    end
  end

  livecheck do
    url :stable
    regex(%r{^releasev?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57ddf8c5212d64a4f020a81aae18dfcc9136da823b05b3ad313f5fb4c006a69b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ba9d968b0a6c5fffa370d8c8b3bb925fdd1929478b4304a20ca94c6f36ace14"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6be8d4f4f6eb461070f5761a85c695233fa631823767cff29a67284c876361f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "7cc7cfb5bb5fe886506174d107a4eb04fa8cdc00812bd61b0f90fd8c8bf6bfe5"
    sha256 cellar: :any_skip_relocation, ventura:       "cc065eeeb4fbb8c4719c1a1914f128485bdc17d7f16d36e80382c381daaf2d6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b588df4b860d781ab5e6c46e84cdd709da5344791f5359f4dbe586bcd4393297"
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