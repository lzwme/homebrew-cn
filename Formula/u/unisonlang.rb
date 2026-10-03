class Unisonlang < Formula
  desc "Friendly programming language from the future"
  homepage "https://unison-lang.org/"
  license "MIT"

  stable do
    url "https://ghfast.top/https://github.com/unisonweb/unison/archive/refs/tags/release/1.5.0.tar.gz"
    sha256 "74f1327e94199a93d97619268744f186c5a1b7d0b1af7ce1f35799137d1d1357"

    resource "local-ui" do
      url "https://ghfast.top/https://github.com/unisonweb/unison-local-ui/archive/refs/tags/release/1.5.0.tar.gz"
      sha256 "d4cc5538f3826da2665c494c2cb6253dd2ffa60fe1cbdce48ba2543e293cc04b"

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
    sha256 cellar: :any, arm64_tahoe:   "ffb7b68f53788bb18f1811a571196cff31a0671274e420457b79311c34a8a63a"
    sha256 cellar: :any, arm64_sequoia: "40e7cb1fd92bbb37a8346f5f52c7807091ac44703155e8f68684a7faeba74560"
    sha256 cellar: :any, arm64_linux:   "5bb9d4f360807834e59d5a606ef2c33a6ef33f7d221bee0cc089b2e6582f7fe6"
    sha256 cellar: :any, x86_64_linux:  "2c04e3f8016eb807fb4c32965820c29b754b520ffe3675b10dbd216319ac0978"
  end

  head do
    url "https://github.com/unisonweb/unison.git", branch: "trunk"

    resource "local-ui" do
      url "https://github.com/unisonweb/unison-local-ui.git", branch: "main"
    end
  end

  depends_on "elm" => :build
  depends_on "elm-format" => :build
  depends_on "ghc@9.10" => :build
  depends_on "haskell-stack" => :build
  depends_on "node" => :build
  depends_on "pkgconf" => :build
  depends_on "libyaml"

  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build
  uses_from_macos "sqlite"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    odie "local-ui resource needs to be updated" if build.stable? && version != resource("local-ui").version

    jobs = ENV.make_jobs
    ENV.deparallelize

    # Build and install the web interface
    resource("local-ui").stage do
      ENV["npm_config_ignore_scripts"] = "elm,elm-format"

      # Loosen the elm-version range to compatible versions as we are not using npm installed copy.
      inreplace "elm.json", /"elm-version": "[0-9.]+"/, "\"elm-version\": \"#{Formula["elm"].version}\""

      system "npm", "install", *std_npm_args(prefix: false)
      # Install missing peer dependencies
      system "npm", "install", *std_npm_args(prefix: false), "favicons"

      # Wire the real binaries into node_modules
      ln_sf formula_opt_bin("elm")/"elm", "node_modules/elm/bin/elm"
      ln_sf formula_opt_bin("elm-format")/"elm-format", "node_modules/elm-format/bin/elm-format"

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
      --flag=direct-sqlite:systemlib
      --flag=libyaml:system-libyaml
      --flag=persistent-sqlite:systemlib
      --flag=persistent-sqlite:use-pkgconfig
      --jobs=#{jobs}
      --local-bin-path=#{prefix}
      --no-install-ghc
      --skip-ghc-check
      --system-ghc
    ]
    if OS.linux?
      stack_args << "--ghc-options=-pie"

      # Using global configuration to apply options to all dependencies
      Pathname("#{Dir.home}/.stack/config.yaml").write <<~YAML
        ghc-options:
          "$everything": -split-sections -fPIC -fexternal-dynamic-refs
      YAML
    end

    system "stack", "install", *stack_args
    bin.install_symlink prefix/"unison" => "ucm"
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