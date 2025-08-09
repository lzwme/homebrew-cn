class Unisonlang < Formula
  desc "Friendly programming language from the future"
  homepage "https://unison-lang.org/"
  license "MIT"

  stable do
    url "https://github.com/unisonweb/unison.git",
        tag:      "release/0.5.45",
        revision: "7867a491c60808622725f7a8170ae7df8f4825a0"

    resource "local-ui" do
      url "https://ghfast.top/https://github.com/unisonweb/unison-local-ui/archive/refs/tags/release/0.5.45.tar.gz"
      sha256 "31e930c3ad4b149d5c2aba7d48913821a19e530ef5bea5030806e0a114b8b77d"

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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "945d09f7fb0c635556f2ad86c2da4179879578feaa4d0f9a218b4963724e6f49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0936bfea54838f0c03d19afcfbc79218df232a61e334cfe7ddc416e940ce6a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9ccdf9d99dc0d1d8d8f344163ba10ef97af2d98986ba016659c0afc75468c61a"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef44ab9ea8c2d7edf6458ffb0019f5fe1ba149d23b343532c49a5bb8197bb444"
    sha256 cellar: :any_skip_relocation, ventura:       "480af87b319f5a88ddc47fc45e08f79c1bc26b0dae7bfa7a9efa2d574b8c1b4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b45d7ae6a36d3eff6601bb999cbdbfa7fbfb5b87150c89ead37c7ce56be9209"
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