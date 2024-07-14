class Llgo < Formula
  desc "Go compiler based on LLVM integrate with the C ecosystem and Python"
  homepage "https:github.comgoplusllgo"
  url "https:github.comgoplusllgoarchiverefstagsv0.9.1.tar.gz"
  sha256 "4298c0670d088db0faab6aa8bd1b3649d09ba1cf75c0e02171a446f6cd3fc1dd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "26df457b0095ea1e8695cebdf87cfeac93a1645ae4c72805279a2ac6c02d696e"
    sha256 cellar: :any,                 arm64_ventura:  "a8c21824ee916d81cb34c77240b361287f7afeffd17a8eb21fdc0f5153b31849"
    sha256 cellar: :any,                 arm64_monterey: "ac8e670daed38d90f1e672bbf60feedd43e510a9495e13b6688c2ff8ea0cab4c"
    sha256 cellar: :any,                 sonoma:         "1ebbc9f5ca2046e31265c38c48b440d6a2ecce637b48e8c70a151ae73bad9eca"
    sha256 cellar: :any,                 ventura:        "866bc6abc4b8b4e794e2fc0a87705d1ae00b0a6ff5df87e6d3589b439b3b0037"
    sha256 cellar: :any,                 monterey:       "d5353cc1308d15b5ffd2e4c16efa3026cfdcd48a0f87072eb15335acd4ba4bc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c58d95df55862f8df250f0f479401793eabc0c1a3f1d2b10eacf62bf66cddaa"
  end

  depends_on "bdw-gc"
  depends_on "cjson"
  depends_on "go"
  depends_on "llvm"
  depends_on "pkg-config"
  depends_on "python@3.12"
  depends_on "raylib"
  depends_on "sqlite"
  depends_on "zlib"

  def install
    ENV["GOBIN"] = libexec"bin"
    ENV.prepend "CGO_LDFLAGS", "-L#{Formula["llvm"].opt_lib}"
    system "go", "install", "...."

    Dir.glob("****.lla").each do |f|
      system "unzip", f, "-d", File.dirname(f)
    end

    libexec.install Dir["*"] - Dir[".*"]

    path = %w[llvm go pkg-config].map { |f| Formula[f].opt_bin }.join(":")
    opt_lib = %w[bdw-gc cjson raylib zlib raylib].map { |f| Formula[f].opt_lib }.join(":")

    (libexec"bin").children.each do |f|
      next if f.directory?

      cmd = File.basename(f)
      (bincmd).write_env_script libexec"bin"cmd,
        LLGOROOT:        libexec,
        PATH:            "#{path}:$PATH",
        LD_LIBRARY_PATH: "#{opt_lib}:$LD_LIBRARY_PATH"
    end
  end

  test do
    (testpath"hello.go").write <<~EOS
      package main

      import "github.comgoplusllgoc"

      func main() {
        c.Printf(c.Str("Hello LLGO\\n"))
      }
    EOS

    (testpath"go.mod").write <<~EOS
      module hello
    EOS

    system "go", "get", "github.comgoplusllgoc"
    system bin"llgo", "build", "-o", "hello", "."
    opt_lib = %w[bdw-gc cjson raylib zlib raylib].map { |f| Formula[f].opt_lib }.join(":")
    output = Utils.popen_read({ "LD_LIBRARY_PATH" => "#{opt_lib}:$LD_LIBRARY_PATH" }, ".hello")
    assert_equal "Hello LLGO\n", output
  end
end