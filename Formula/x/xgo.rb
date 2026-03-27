class Xgo < Formula
  desc "AI-native programming language that integrates software engineering"
  homepage "https://xgo.dev/"
  url "https://ghfast.top/https://github.com/goplus/xgo/archive/refs/tags/v1.6.8.tar.gz"
  sha256 "0289779ddd06a55e4367246a2a872b7da75c913796ff35e126c06d29f3181398"
  license "Apache-2.0"
  head "https://github.com/goplus/xgo.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "79020b89a26a18685b58789f50b1ec5d948fc1a6948106e1dede95d1d4229d62"
    sha256 arm64_sequoia: "79020b89a26a18685b58789f50b1ec5d948fc1a6948106e1dede95d1d4229d62"
    sha256 arm64_sonoma:  "79020b89a26a18685b58789f50b1ec5d948fc1a6948106e1dede95d1d4229d62"
    sha256 sonoma:        "100ed772a3f4b125d868c53198bab18ff3c1db938fdd9e729fd711ea6f154090"
    sha256 arm64_linux:   "2254cf4808dddec4cdf5eb6c99514fa4cac5000da20895e521350651e846b5e5"
    sha256 x86_64_linux:  "3ad5396c9092ee7baba379dd478df2d74b428d45d19a9ba6ce98191b4ce1f425"
  end

  depends_on "go"

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -X github.com/goplus/xgo/env.buildVersion=v#{version}
      -X github.com/goplus/xgo/env.buildDate=#{time.strftime("%Y-%m-%d")}
      -X github.com/goplus/xgo/env.defaultXGoRoot=#{libexec}
    ]

    system "go", "build", *std_go_args(ldflags:, output: libexec/"bin/xgo"), "./cmd/xgo"

    # gop is a symlink to xgo
    (libexec/"bin").install_symlink "xgo" => "gop"

    # Install source files (required for XGOROOT validation)
    libexec.install Dir["*"] - Dir[".*"] - ["bin"]
    bin.install_symlink Dir[libexec/"bin/*"]

    generate_completions_from_executable(bin/"xgo", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xgo version")

    system bin/"xgo", "mod", "init", "hello"
    (testpath/"hello.xgo").write <<~XGO
      println("Hello World")
    XGO

    # Run xgo fmt, run, build
    system bin/"xgo", "fmt", "hello.xgo"
    assert_equal "Hello World\n", shell_output("#{bin}/xgo run hello.xgo 2>&1")
    system bin/"xgo", "build", "-o", "hello"
    assert_equal "Hello World\n", shell_output("./hello 2>&1")
  end
end