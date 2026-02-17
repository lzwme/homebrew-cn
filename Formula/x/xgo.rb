class Xgo < Formula
  desc "AI-native programming language that integrates software engineering"
  homepage "https://xgo.dev/"
  url "https://ghfast.top/https://github.com/goplus/xgo/archive/refs/tags/v1.6.3.tar.gz"
  sha256 "5b0536613a4017ed7565746991d5f7c711a6c792493b569482e2bb341e635b92"
  license "Apache-2.0"
  head "https://github.com/goplus/xgo.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "a988fb8dd5285ed677c5eb3c57e7fa78e999abb8c72cc09b7d89d0e2066ea1b1"
    sha256 arm64_sequoia: "fe16d1167f844a869cd2dee50d59ce24ae7aba171ef3efec89bfde802e355c7e"
    sha256 arm64_sonoma:  "961c48f5ba31c63b330fa465a20c513ab84a7b2da82fa71564793d46d2918753"
    sha256 sonoma:        "bf955d390b91a02bae29d88cd3bdf538791dca6f3d4b22fd200e76c27e89e914"
    sha256 arm64_linux:   "cd7d5651fa636b993e7edafb57ca5073abc29563b13716d85c0cfc8949c1e573"
    sha256 x86_64_linux:  "7dbfc29c04acb19e0867a7cad211cfa550804c656ef19b2492ec5fa51fd4dba3"
  end

  depends_on "go"

  def install
    ENV["GOPROOT_FINAL"] = libexec

    # Add VERSION file
    (buildpath/"VERSION").write version

    system "go", "run", "cmd/make.go", "--install"

    libexec.install Dir["*"] - Dir[".*"]
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