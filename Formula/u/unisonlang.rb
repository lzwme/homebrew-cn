class Unisonlang < Formula
  desc "Friendly programming language from the future"
  homepage "https://unison-lang.org/"
  license "MIT"

  stable do
    url "https://github.com/unisonweb/unison.git",
        tag:      "release/1.0.0",
        revision: "177d0635420f2dd9d0ba425d65eea5911253d5bb"

    resource "local-ui" do
      url "https://ghfast.top/https://github.com/unisonweb/unison-local-ui/archive/refs/tags/release/1.0.0.tar.gz"
      sha256 "8e7fbe261f84ae8d4ccbb144d5fe71bf7b48dbdf05219d9db10541f5b995e1cf"

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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a3bec3dee914213c4c1bf65db1b45763090eb973d5206511db9dbc824f5a7904"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fcbeb107ebc64e1e5dad4538c1caf97fccbb3d4ce0706ddd5a5d401394153c74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2ea9a344257f401e24904fabcd44b09072b5f6c553ce1c8eb49488f0ad65a29"
    sha256 cellar: :any_skip_relocation, sonoma:        "27c34820d33707ffe1c7b91a43d9503a63a15f0d33e00b906c652787f3da5feb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c6bb333689eb301534d9650a8adcfb8d93c9b8dc62c7ed275d6e5e388ca6d58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66137726856464aa0c5cff7e6a4c147312cba1950d832528ea8d315a86824a95"
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
  # FIXME: `html-webpack-plugin` for `local-ui` fails to build on node 25+
  # https://github.com/jantimon/html-webpack-plugin/pull/1880
  depends_on "node@24" => :build

  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build
  uses_from_macos "zlib"

  def install
    odie "local-ui resource needs to be updated" if build.stable? && version != resource("local-ui").version

    jobs = ENV.make_jobs
    ENV.deparallelize

    # Build and install the web interface
    resource("local-ui").stage do
      ENV["npm_config_ignore_scripts"] = "elm,elm-format"

      system "npm", "install", *std_npm_args(prefix: false)
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