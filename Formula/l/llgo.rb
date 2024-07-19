class Llgo < Formula
  desc "Go compiler based on LLVM integrate with the C ecosystem and Python"
  homepage "https:github.comgoplusllgo"
  url "https:github.comgoplusllgoarchiverefstagsv0.9.2.tar.gz"
  sha256 "a3bf64aadefee0d145f823b8271c08e1ee24ca182bd2b354d8c667a6d4fdcc28"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "416bc5f4f991dc57675db343caded2d87d5005fae4e5d9235f0c3541338b1409"
    sha256 cellar: :any, arm64_ventura:  "fadfbff07c6d431da832d258add1e4a44a6ad5a6085a551f4407ec9ac232601c"
    sha256 cellar: :any, arm64_monterey: "9ddb406673e6e7c5ded6585d9043e155eebf4fc43016cfc6bfeb8f405bba4f7f"
    sha256 cellar: :any, sonoma:         "b75dd458eb731d05d91eb47bdc4ece03a717e2bf1134309d16afe2f11972103e"
    sha256 cellar: :any, ventura:        "4c78c7dd099f3fb0c60b2f1cfe61c5854a2052d79b52cf8faba5fa8117c737c1"
    sha256 cellar: :any, monterey:       "c199cdc38680c021476adc2a47b8bdf7e22889c951f15609a54cdac3db24aac9"
    sha256               x86_64_linux:   "1250c4dda1151db845be75acf9076a0ba403d1a2c423690a73dcba5e27885ee8"
  end

  depends_on "bdw-gc"
  depends_on "go"
  depends_on "llvm"
  depends_on "pkg-config"

  def install
    if OS.linux?
      ENV.prepend "CGO_CPPFLAGS",
        "-I#{Formula["llvm"].opt_include} " \
        "-D_GNU_SOURCE " \
        "-D__STDC_CONSTANT_MACROS " \
        "-D__STDC_FORMAT_MACROS " \
        "-D__STDC_LIMIT_MACROS"
      ENV.prepend "CGO_LDFLAGS", "-L#{Formula["llvm"].opt_lib} -lLLVM"
    end

    ldflags = %W[
      -s -w
      -X github.comgoplusllgoxtoolenv.buildVersion=v#{version}
      -X github.comgoplusllgoxtoolenv.buildDate=#{time.iso8601}
      -X github.comgoplusllgoxtoolenvllvm.ldLLVMConfigBin=#{Formula["llvm"].opt_bin"llvm-config"}
    ]
    build_args = *std_go_args(ldflags:)
    build_args += ["-tags", "byollvm"] if OS.linux?
    system "go", "build", *build_args, "-o", libexec"bin", ".cmdllgo"

    libexec.install "LICENSE", "README.md"

    path = %w[go llvm pkg-config].map { |f| Formula[f].opt_bin }.join(":")
    opt_lib = %w[bdw-gc].map { |f| Formula[f].opt_lib }.join(":")

    (libexec"bin").children.each do |f|
      next if f.directory?

      cmd = File.basename(f)
      (bincmd).write_env_script libexec"bin"cmd,
        PATH:            "#{path}:$PATH",
        LD_LIBRARY_PATH: "#{opt_lib}:$LD_LIBRARY_PATH"
    end
  end

  test do
    opt_lib = %w[bdw-gc].map { |f| Formula[f].opt_lib }.join(":")
    ENV.prepend_path "LD_LIBRARY_PATH", opt_lib

    goos = shell_output(Formula["go"].opt_bin"go env GOOS").chomp
    goarch = shell_output(Formula["go"].opt_bin"go env GOARCH").chomp
    assert_equal "llgo v#{version} #{goos}#{goarch}", shell_output("#{bin}llgo version").chomp unless head?

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
    system Formula["go"].opt_bin"go", "get", "github.comgoplusllgo@v#{version}"
    system bin"llgo", "build", "-o", "hello", "."
    assert_equal "Hello LLGO\n", shell_output(".hello")
  end
end