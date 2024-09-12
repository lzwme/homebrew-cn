class Unisonlang < Formula
  desc "Friendly programming language from the future"
  homepage "https:unison-lang.org"
  license "MIT"

  stable do
    url "https:github.comunisonwebunison.git",
        tag:      "release0.5.26",
        revision: "9af301da7fddfa21bb7b3b8b7b34cbbc14cb1e2a"

    resource "local-ui" do
      url "https:github.comunisonwebunison-local-uiarchiverefstagsrelease0.5.26.tar.gz"
      sha256 "5562f3ff856a469182526009b2543785e7b725dd01b69f55adb0fa0ae6f00d61"
    end
  end

  livecheck do
    url :stable
    regex(%r{^releasev?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "63d5ba4e65a5588b3d888690f029befdab9f39512836782a69cdee61749e0db1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d185b2abbfee5b7088238e9ce5ed9480d074b17e05d6727ca965d15afb501e0b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6339bf22214ddc13e99859021ef98708491a8e0bd190eccf4c6e928c9cfc4295"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c23ce3f4a38e06e4000e9edfd8a6b8a4e48bf816ef49735d1639f9fc3e4c5f6d"
    sha256 cellar: :any_skip_relocation, sonoma:         "d0e82fe2fa0b98a9e485333ccca3a50804d69a8e1a85630df5421621045eefff"
    sha256 cellar: :any_skip_relocation, ventura:        "ad38c11621c4d545a347d5320fd1dd5cfe73381a0a42d2d7c0763ad3113b597b"
    sha256 cellar: :any_skip_relocation, monterey:       "b04c66e140370e3845dea87d5156b22b598fa3d0bb39cbc3aca67dca642d1fe1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ec8e143b4fae30f159a0e3817eb6b79bbef5ac8cfb686601f0c8c6f75fc8c1d"
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

    system "stack", "-j#{jobs}", "build", "--flag", "unison-parser-typechecker:optimized", *stack_args

    prefix.install "unison" => "ucm"
    bin.install_symlink prefix"ucm"
  end

  test do
    (testpath"hello.u").write <<~EOS
      helloTo : Text ->{IO, Exception} ()
      helloTo name =
        printLine ("Hello " ++ name)

      hello : '{IO, Exception} ()
      hello _ =
        helloTo "Homebrew"
    EOS

    (testpath"hello.md").write <<~EOS
      ```ucm
      scratchmain> project.create test
      testmain> load hello.u
      testmain> add
      testmain> run hello
      ```
    EOS

    assert_match "Hello Homebrew", shell_output("#{bin}ucm --codebase-create . transcript.fork hello.md")
  end
end