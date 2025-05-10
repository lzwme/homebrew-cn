class Unisonlang < Formula
  desc "Friendly programming language from the future"
  homepage "https:unison-lang.org"
  license "MIT"

  stable do
    url "https:github.comunisonwebunison.git",
        tag:      "release0.5.40",
        revision: "468e355113bbad2f72d18ce27788f4323b0784b3"

    resource "local-ui" do
      url "https:github.comunisonwebunison-local-uiarchiverefstagsrelease0.5.40.tar.gz"
      sha256 "d7e929e0de9e45f56e9ed3bc1e95591aa60dbb28f0de35a19afaeb7ac29d9be3"

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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75c91467d276477fd34e624af8ac4e44fd16aff613e1596d55b7c14ff303556d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb94cd1e12115c8e58adde03f1d0cfc26ef36f6a1b7a60a251adeb425c424390"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8602c23752ec792b7171110c625c445fd1f60a08b0080006aeca7582c736e000"
    sha256 cellar: :any_skip_relocation, sonoma:        "2363ae68bd1e50902effe27beffba9de2cb441f6dc22e2e2e32aa454e319e655"
    sha256 cellar: :any_skip_relocation, ventura:       "07d831bcbf16c85dc0ac123645507310f615682f33f31db750512184c59c8f7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2f6729b7fe8b4e64813d56c94948d0f9c6465ddea444207261dead45923ddc2"
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