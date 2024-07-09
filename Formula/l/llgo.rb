class Llgo < Formula
  desc "Go compiler based on LLVM integrate with the C ecosystem and Python"
  homepage "https:github.comgoplusllgo"
  url "https:github.comgoplusllgoarchiverefstagsv0.9.0.tar.gz"
  sha256 "fdf145f85b2570a50e4bdf29ae2bf93f2197b16546e3bce37c4622eee97f39cb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1d6e32db706cf4ab6e9087b4197c0d9e829559ac336f3ad6c617b2c49471497c"
    sha256 cellar: :any,                 arm64_ventura:  "c104959502b64c956e0143272a070e4cd5844e185af6fb930d33abc9cb51a10b"
    sha256 cellar: :any,                 arm64_monterey: "cbb8e6a856ebe25ef8f52d337f284e09e2c9a5cec3771123fd2b04a6d4b3881f"
    sha256 cellar: :any,                 sonoma:         "9d646b31abe3b91c0d055de26444a1b7035d793e937e3fb653120a6d47849f54"
    sha256 cellar: :any,                 ventura:        "7ce36bdaef8e762797deaf1694be9975389126e7083998278c50b5f2c15ee010"
    sha256 cellar: :any,                 monterey:       "ad9b4d3a38da553396ded11959777a717fd23b8d6fc6ff94622956616a7a1eac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21170472c5998a024cf70865c50c4a2be44e6913653e1522ba2c7d75523c030e"
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