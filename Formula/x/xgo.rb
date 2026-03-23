class Xgo < Formula
  desc "AI-native programming language that integrates software engineering"
  homepage "https://xgo.dev/"
  url "https://ghfast.top/https://github.com/goplus/xgo/archive/refs/tags/v1.6.6.tar.gz"
  sha256 "ec314d77477b62adb2c297931ad1cb4c1f197194a465209de81218ceebd6089b"
  license "Apache-2.0"
  head "https://github.com/goplus/xgo.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "3c7dc19ca1cd86e82d313c14726c5cb0c207974983806313106934bcf03d143b"
    sha256 arm64_sequoia: "3c7dc19ca1cd86e82d313c14726c5cb0c207974983806313106934bcf03d143b"
    sha256 arm64_sonoma:  "3c7dc19ca1cd86e82d313c14726c5cb0c207974983806313106934bcf03d143b"
    sha256 sonoma:        "958c6902406feb814beed05766e094888b5ee87dd6ea8be658e3855e2314eecb"
    sha256 arm64_linux:   "1609dfb3658109b13c0d589512f0accf16f5822929c2056224d40f06c6243bca"
    sha256 x86_64_linux:  "1a30d84381ce9bd456b63054e7f1e36fa0483c3d7eb52091c02b2896a2eb8526"
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