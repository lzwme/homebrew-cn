class Solod < Formula
  desc "Strict subset of Go with transpiler that translates to regular C"
  homepage "https://solod.dev/"
  url "https://github.com/solod-dev/solod.git",
    tag:      "v0.3.0",
    revision: "b4a71c0a7ec37a1657938f262ad8fa9bf55b46d4"
  license "BSD-3-Clause"
  head "https://github.com/solod-dev/solod.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8fad6c9011a1a002966203a8401e232c5161784d413315647da2a6513783a243"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fad6c9011a1a002966203a8401e232c5161784d413315647da2a6513783a243"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fad6c9011a1a002966203a8401e232c5161784d413315647da2a6513783a243"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9463386f770f8346bbc93505e512e7be478047e2e51797e10d4d720967c18d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4f16b7b3377cba9bfa604f3f9bae26f946f8c997bebb596a559e6343c522114"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dafbbd92149d5608787592c39fcb22d96b2a1086df8212f1b6d77ed5adb50d44"
  end

  depends_on "go" => [:build, :test]

  conflicts_with "so", because: "both install `so` binaries"

  def install
    system "go", "build", *std_go_args(output: bin/"so"), "./cmd/so"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/so version")

    (testpath/"main.go").write <<~GO
      package main

      func main() {
      	println("Hello, World!")
      }
    GO

    system "go", "mod", "init", "testproject"

    assert_match "Hello, World!", shell_output("#{bin}/so run .")

    system bin/"so", "translate", "."
    assert_path_exists testpath/"main.c"
    assert_match "int main(void)", (testpath/"main.c").read
    assert_match "\"Hello, World!\"", (testpath/"main.c").read

    system ENV.cc, "-o", "main", "main.c", "so/builtin/builtin.c"
    assert_match "Hello, World!", shell_output("./main")
  end
end