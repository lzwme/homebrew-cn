class Unisonlang < Formula
  desc "Friendly programming language from the future"
  homepage "https://unison-lang.org/"
  license "MIT"

  stable do
    url "https://ghfast.top/https://github.com/unisonweb/unison/archive/refs/tags/release/1.3.0.tar.gz"
    sha256 "9a9c53fcb7a6913504d3356b5661eae33c28271d6253fd5cb08cb5e93bd67295"

    resource "local-ui" do
      url "https://ghfast.top/https://github.com/unisonweb/unison-local-ui/archive/refs/tags/release/1.3.0.tar.gz"
      sha256 "80e097c82b6a38f16d3c3b42463c331e3e63f4d39f4360d894c82dd447237bee"

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
    rebuild 2
    sha256 cellar: :any, arm64_tahoe:   "4de5a870d24353cf61446d20b66563aaff8d3b7cbbc5bdf6996fa3679a4c606b"
    sha256 cellar: :any, arm64_sequoia: "cd704f4f317b10defdd31d3dd4a9b8e8cb33f4e027dd8ef8c8cff6df7eede96e"
    sha256 cellar: :any, arm64_sonoma:  "baa9e8b7ff3893ecc28d0560b8ed257fae625fa49298e2b0239fe608e6435b57"
    sha256 cellar: :any, sonoma:        "a86929f4a586fdec23b082bd83b6c8862a0dba013edd8be6be7b3ed7786a723d"
    sha256 cellar: :any, arm64_linux:   "ab02cb2f9d303085c6682a1a667322932fb05559cb88f1f05f8bec28fe3dfea4"
    sha256 cellar: :any, x86_64_linux:  "ea7a04ca72740e8f4ff79334ccd8ed651de5046ebba835c9462669b0b6861750"
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