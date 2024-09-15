class Llgo < Formula
  desc "Go compiler based on LLVM integrate with the C ecosystem and Python"
  homepage "https:github.comgoplusllgo"
  url "https:github.comgoplusllgoarchiverefstagsv0.9.7.tar.gz"
  sha256 "f9721be0b41d1e622923b4aa1d4e8071af93753f36f4c9285697e6af009fa0dc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sequoia:  "9662d4ef9ac28e8fa0fb323e72639f9ff1b8929d2b92a3310968eb21972e5df3"
    sha256 cellar: :any, arm64_sonoma:   "096384f0999a2144455e1274e974513e00fee6931a7848d00e51ee60b0314bdc"
    sha256 cellar: :any, arm64_ventura:  "f55927a3fed5185bb7046e5eea964e5384305d786f9e058c2c6e3182f1d164c2"
    sha256 cellar: :any, arm64_monterey: "8ebe3c5d24fdf1eb1e210573a430543a0fad5a7db053567dce7bede2eaa6b8c5"
    sha256 cellar: :any, sonoma:         "c6724135cda194af9684186b4c245efd186a3127ea578dd7dcba0d64de5fea5c"
    sha256 cellar: :any, ventura:        "2a646f5b2f82ccdbeae2f3024000015f1f8c597801eae85454961c774694a0cd"
    sha256 cellar: :any, monterey:       "3ea493908db3bdfa0c2b851920fe7d6a956244f504a9cc0547bbfa6e310bda0a"
    sha256               x86_64_linux:   "9eb63752090ea065305ff4ffa581f9e6bdc0fbfe34da5a8b977f6059b5038888"
  end

  depends_on "bdw-gc"
  depends_on "go"
  depends_on "llvm"
  depends_on "openssl@3"
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
      -X github.comgoplusllgoxenv.buildVersion=v#{version}
      -X github.comgoplusllgoxenv.buildTime=#{time.iso8601}
      -X github.comgoplusllgoxtoolenvllvm.ldLLVMConfigBin=#{Formula["llvm"].opt_bin"llvm-config"}
    ]
    build_args = *std_go_args(ldflags:)
    build_args += ["-tags", "byollvm"] if OS.linux?
    system "go", "build", *build_args, "-o", libexec"bin", ".cmdllgo"

    libexec.install "LICENSE", "README.md"

    path = %w[go llvm pkg-config].map { |f| Formula[f].opt_bin }.join(":")
    opt_lib = %w[bdw-gc openssl@3].map { |f| Formula[f].opt_lib }.join(":")

    (libexec"bin").children.each do |f|
      next if f.directory?

      cmd = File.basename(f)
      (bincmd).write_env_script libexec"bin"cmd,
        PATH:            "#{path}:$PATH",
        LD_LIBRARY_PATH: "#{opt_lib}:$LD_LIBRARY_PATH"
    end
  end

  test do
    opt_lib = %w[bdw-gc openssl@3].map { |f| Formula[f].opt_lib }.join(":")
    ENV.prepend_path "LD_LIBRARY_PATH", opt_lib

    goos = shell_output(Formula["go"].opt_bin"go env GOOS").chomp
    goarch = shell_output(Formula["go"].opt_bin"go env GOARCH").chomp
    assert_equal "llgo v#{version} #{goos}#{goarch}", shell_output("#{bin}llgo version").chomp

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