class Unisonlang < Formula
  desc "Friendly programming language from the future"
  homepage "https:unison-lang.org"
  license "MIT"

  stable do
    url "https:github.comunisonwebunison.git",
        tag:      "release0.5.34",
        revision: "63b59ffff35687d646cd222296920bd6c1e052d9"

    resource "local-ui" do
      url "https:github.comunisonwebunison-local-uiarchiverefstagsrelease0.5.34.tar.gz"
      sha256 "26935abf5f3b97ac1b2b8aea27824eb2c711e17a6a3980c39176292f693743e1"

      livecheck do
        formula :parent
      end
    end
  end

  livecheck do
    url :stable
    regex(%r{^releasev?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08179e40cb07c6e31ff855cbf659efda028da0d059fd797dba75ad69e4ceb52b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a6ae2aa7753d735718f591958672e089b1b0caeb3d05376b9eec552c53c07f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d89620ba7b2a530d96c12bfca70d45252255e12fbe3ed18e793e23b31c48e8da"
    sha256 cellar: :any_skip_relocation, sonoma:        "d44647310c45e9887096178faf1c19a60a59a6ba05ea2446bb18199cb6e2299e"
    sha256 cellar: :any_skip_relocation, ventura:       "503177a05ecbabc73953b3b2c82db4490b46ae649b82901214a676b34fd19a85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a787697ae703005a187afbb01b3c83d8c9f2a5fd182aa162e905c2546c6aa9f8"
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
  depends_on "node" => :build

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