class Xgo < Formula
  desc "AI-native programming language that integrates software engineering"
  homepage "https://xgo.dev/"
  url "https://ghfast.top/https://github.com/goplus/xgo/archive/refs/tags/v1.5.3.tar.gz"
  sha256 "af10b9e8d3980e4c4f4b9bf3d341e3d1dd72d1324ca26825b360c3ce865b7da0"
  license "Apache-2.0"
  head "https://github.com/goplus/xgo.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "a75c004854a1a9bc80a4cf44e9587d66fea27e47c3d766cd51d51b7c02df3006"
    sha256 arm64_sequoia: "0833d3abb66a496f7f4dac08bbb60e140213560acc6b88044d3c275bcd2ef268"
    sha256 arm64_sonoma:  "4d9fd8b8ef8b25a88fc0e34c480f07ef2a8057f3aae157d774e3aa1f51959be1"
    sha256 sonoma:        "9af23dadf176158e70483d0647a4562f627975335664c868f94e1ea33b24a9ce"
    sha256 arm64_linux:   "b836969dc91f0841cfaef9a87fdc1a7ed3efd1dc7bb45a60ede2845573bc0491"
    sha256 x86_64_linux:  "928ebd50cc947e4aab439df06de50e88b70345bed28e63b7dd84d3a685678db3"
  end

  depends_on "go"

  def install
    ENV["GOPROOT_FINAL"] = libexec
    system "go", "run", "cmd/make.go", "--install"

    libexec.install Dir["*"] - Dir[".*"]
    bin.install_symlink Dir[libexec/"bin/*"]

    generate_completions_from_executable(bin/"xgo", "completion")
  end

  test do
    system bin/"xgo", "mod", "init", "hello"
    (testpath/"hello.xgo").write <<~XGO
      println("Hello World")
    XGO

    # Run xgo fmt, run, build
    assert_equal "v#{version}", shell_output("#{bin}/xgo env XGOVERSION").chomp
    system bin/"xgo", "fmt", "hello.xgo"
    assert_equal "Hello World\n", shell_output("#{bin}/xgo run hello.xgo 2>&1")
    system bin/"xgo", "build", "-o", "hello"
    assert_equal "Hello World\n", shell_output("./hello 2>&1")
  end
end