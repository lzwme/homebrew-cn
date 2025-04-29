class Unisonlang < Formula
  desc "Friendly programming language from the future"
  homepage "https:unison-lang.org"
  license "MIT"

  stable do
    url "https:github.comunisonwebunison.git",
        tag:      "release0.5.38",
        revision: "1e733a47e1220423a710d8d63bae5f232e0b83c4"

    resource "local-ui" do
      url "https:github.comunisonwebunison-local-uiarchiverefstagsrelease0.5.38.tar.gz"
      sha256 "90e289f5979989cd0dd6f321263494e6300e39a572f46813f957c098f90b38e4"

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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b804d704e293c67bf2eabbd062fcf14c936dfcc9c838b244dacbb84e9ed0bbb0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4fd4d9d24e2f1d40808123415cb607a00e2987a61cee4609650668dc7b6c7008"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0396b605597abc49197bc3687d638aaa003134af93bc5ebd497080b3852a8fdb"
    sha256 cellar: :any_skip_relocation, sonoma:        "89566d873fb483c0a6589d12851af829b37b610c59695603467fb3102cce2366"
    sha256 cellar: :any_skip_relocation, ventura:       "f3179569002cf8f3ca538aea873cc9ca0d1365da61f7b7565d708ac2bc3f53a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f78fcddaae2243ceaafe60cc54b39c99d61a087a4552cdd6c8f5d7c97769f333"
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