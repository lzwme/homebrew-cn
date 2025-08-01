class Unisonlang < Formula
  desc "Friendly programming language from the future"
  homepage "https://unison-lang.org/"
  license "MIT"

  stable do
    url "https://github.com/unisonweb/unison.git",
        tag:      "release/0.5.44",
        revision: "dbd7a1fcdf0b32cc053474838af5e5453bc6cc2a"

    resource "local-ui" do
      url "https://ghfast.top/https://github.com/unisonweb/unison-local-ui/archive/refs/tags/release/0.5.44.tar.gz"
      sha256 "e403edd5324221c415aff0e5849ae52bad5db51e7c83df5a106be51ef85f8cf2"

      livecheck do
        formula :parent
      end
    end
  end

  livecheck do
    url :stable
    regex(%r{^release/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83e245b75c2b0972fdc064f7fa298b5739ecc2cbd92e9d516825b4c427908f99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e54bf7badbf8a597c6fadd7584c2a7e1141e683e1ab57f958cdf394a1014504"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fe00f371db67d4d50023e4243f03cdb4c9c89ab19a460f08ad50ae47cb376ac4"
    sha256 cellar: :any_skip_relocation, sonoma:        "a323494ee601645269feee35cbec8925d8eb2f518d3866d612fce11d4962272c"
    sha256 cellar: :any_skip_relocation, ventura:       "8ef4f0cfeec487efa69c92b0a902d5c99dc599f0ea4821ba6d5c56b9f529b153"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cdd99044a9406cf86695a55b7811566eeedcfd7e892b1cdf9b8cbf1a831be4c6"
  end

  head do
    url "https://github.com/unisonweb/unison.git", branch: "trunk"

    resource "local-ui" do
      url "https://github.com/unisonweb/unison-local-ui.git", branch: "main"
    end
  end

  depends_on "elm" => :build
  depends_on "elm-format" => :build
  depends_on "ghc@9.6" => :build
  depends_on "haskell-stack" => :build
  depends_on "node" => :build

  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build
  uses_from_macos "zlib"

  def install
    odie "local-ui resource needs to be updated" if build.stable? && version != resource("local-ui").version

    jobs = ENV.make_jobs
    ENV.deparallelize

    # Build and install the web interface
    resource("local-ui").stage do
      with_env(npm_config_ignore_scripts: "elm,elm-format") do
        system "npm", "install", *std_npm_args(prefix: false)
      end

      # Install missing peer dependencies
      system "npm", "install", *std_npm_args(prefix: false), "favicons"

      # Wire the real binaries into node_modules
      ln_sf Formula["elm"].opt_bin/"elm", "node_modules/elm/bin/elm"
      ln_sf Formula["elm-format"].opt_bin/"elm-format", "node_modules/elm-format/bin/elm-format"

      # HACK: Flaky command occasionally stalls build indefinitely so we force fail
      # if that occurs. Problem seems to happening while running `elm-json install`.
      # Issue ref: https://github.com/zwilias/elm-json/issues/50
      Timeout.timeout(300) do
        system "npm", "run", "ui-core-install"
      end
      system "npm", "run", "build"

      prefix.install "dist/unisonLocal" => "ui"
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
    bin.install_symlink prefix/"ucm"
  end

  test do
    (testpath/"hello.u").write <<~UNISON
      helloTo : Text ->{IO, Exception} ()
      helloTo name =
        printLine ("Hello " ++ name)

      hello : '{IO, Exception} ()
      hello _ =
        helloTo "Homebrew"
    UNISON

    (testpath/"hello.md").write <<~MARKDOWN
      ```ucm
      scratch/main> project.create test
      test/main> load hello.u
      test/main> add
      test/main> run hello
      ```
    MARKDOWN

    assert_match "Hello Homebrew", shell_output("#{bin}/ucm --codebase-create ./ transcript.fork hello.md")
  end
end