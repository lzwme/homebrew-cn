class Unisonlang < Formula
  desc "Friendly programming language from the future"
  homepage "https:unison-lang.org"
  license "MIT"

  stable do
    url "https:github.comunisonwebunison.git",
        tag:      "release0.5.33",
        revision: "49432a6c3463326c3a0fadaea2794a66fdaabde9"

    resource "local-ui" do
      url "https:github.comunisonwebunison-local-uiarchiverefstagsrelease0.5.33.tar.gz"
      sha256 "22ad22c040d41e2c64a891c4831c6481656cbd75df9af12e3f403ca5eb8736b5"

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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62c41baf37e15f36b59fac7122d2de1652d7491262bd7cc7295e95c9179146d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11e84141816d6d600adf9de209b5ce35aeafdb71aa2e41f02a1982eb9b38f586"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3e596a3c8ebece0b336b243b07c7e06b81c11b6274ba60868a1d61885b7535ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3bc2abd54259f0e0996676d636a2614aa5e584ef64a1580ec6519fb3c53b994"
    sha256 cellar: :any_skip_relocation, ventura:       "3d8d02ba4931cb0bb33bd5ceca3d4465ce36beab6891b1c8c0cc0c309c22ee78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67c0cc6315e3124d1d90c422ec4d6808149d644b37bdbd430438c49b5b2ebbc7"
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