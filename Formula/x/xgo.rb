class Xgo < Formula
  desc "AI-native programming language that integrates software engineering"
  homepage "https://xgo.dev/"
  url "https://ghfast.top/https://github.com/goplus/xgo/archive/refs/tags/v1.6.9.tar.gz"
  sha256 "cd9bb7b5cb317bb32c11e8a3b0d42f3fde92b28793bd5f93c39118b014562c77"
  license "Apache-2.0"
  head "https://github.com/goplus/xgo.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "fb24afe72411a91bce5427c84bc1b1fd838e13e75deccf7a04d7c5fa2ba205fa"
    sha256 arm64_sequoia: "fb24afe72411a91bce5427c84bc1b1fd838e13e75deccf7a04d7c5fa2ba205fa"
    sha256 arm64_sonoma:  "fb24afe72411a91bce5427c84bc1b1fd838e13e75deccf7a04d7c5fa2ba205fa"
    sha256 sonoma:        "625dd896a9a200c590f123591bbf0bc41118a089087d02b82ad853a8472b32fd"
    sha256 arm64_linux:   "2e40c595b1998f0bc2aeaac2ac4fedbe6e38debb94ef7f79e66884ce7537c40d"
    sha256 x86_64_linux:  "e41cc283770c7cf4f1148b94153f306c136bd47a1833d471d34785e953028249"
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