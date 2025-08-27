class Unisonlang < Formula
  desc "Friendly programming language from the future"
  homepage "https://unison-lang.org/"
  license "MIT"

  stable do
    url "https://github.com/unisonweb/unison.git",
        tag:      "release/0.5.46",
        revision: "dbeea4d1a10b732bec992f1a0e2847cc7bc0ac93"

    resource "local-ui" do
      url "https://ghfast.top/https://github.com/unisonweb/unison-local-ui/archive/refs/tags/release/0.5.46.tar.gz"
      sha256 "59f4b46736bc1e6a70c9f3d816784d6ca3f8829e8ac576903bffa34d4cd4415d"

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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b7ebc6adb2efd1a890509cf37dd688a41a1e6df2f6a072cb9be5092823a9420"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ec55318623c2bc1249d7adfc3081ef5c1bce868e5e27a8dcac710170120a707"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d8f7965230d08c441f06952e4a6a49c0575516f23387f50ef4d536af736f2640"
    sha256 cellar: :any_skip_relocation, sonoma:        "01c47a399199c3781964237b7fe2f3fbccfa11e667e00e5ee5a0175f8742fa2b"
    sha256 cellar: :any_skip_relocation, ventura:       "ce1443b3fc417c8a5c1592231054a603e42831b418f7c677c99897d30300aa87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4eb4010d7723b06348e2630fc117ac132f68d772ff4d3a8c66a434355004204a"
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