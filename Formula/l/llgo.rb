class Llgo < Formula
  desc "Go compiler based on LLVM integrate with the C ecosystem and Python"
  homepage "https:github.comgoplusllgo"
  url "https:github.comgoplusllgoarchiverefstagsv0.9.8.tar.gz"
  sha256 "8dfb3032457776d128d2dc6edcaefee2ab407c8e95ff3ae83befc2cc6caacf20"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "287e6e801a0611898eb79d6beb4423d7a1833ae260f80be1c7dc6f09b344bc24"
    sha256 cellar: :any, arm64_sonoma:  "67e233608b858e2ac1b823694e6a72b8dff4bf53d535647a54fcb05b0e4e66b4"
    sha256 cellar: :any, arm64_ventura: "74b7cf27f07fba3674e9a2c4ca1418e77033d150dfbcea56afd359697c7c2582"
    sha256 cellar: :any, sonoma:        "07c6c4d88ec169cc5e177d0ea6fe7268290a3b191c340b10cf2650fc6ed69ef8"
    sha256 cellar: :any, ventura:       "ee3cde534de042491014ac773ca3fec7f520d430d56836be7f3cce2e70a45b85"
    sha256               x86_64_linux:  "b229243a980288079c05cc4180e144b9bf89e7368a65f64d2d43ba769f696057"
  end

  depends_on "bdw-gc"
  depends_on "go"
  depends_on "llvm@18"
  depends_on "openssl@3"
  depends_on "pkgconf"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match?(^llvm(@\d+)?$) }
  end

  def install
    if OS.linux?
      ENV.prepend "CGO_CPPFLAGS",
        "-I#{llvm.opt_include} " \
        "-D_GNU_SOURCE " \
        "-D__STDC_CONSTANT_MACROS " \
        "-D__STDC_FORMAT_MACROS " \
        "-D__STDC_LIMIT_MACROS"
      ENV.prepend "CGO_LDFLAGS", "-L#{llvm.opt_lib} -lLLVM"
    end

    ldflags = %W[
      -s -w
      -X github.comgoplusllgoxenv.buildVersion=v#{version}
      -X github.comgoplusllgoxenv.buildTime=#{time.iso8601}
      -X github.comgoplusllgoxtoolenvllvm.ldLLVMConfigBin=#{llvm.opt_bin"llvm-config"}
    ]
    build_args = *std_go_args(ldflags:)
    build_args += ["-tags", "byollvm"] if OS.linux?
    system "go", "build", *build_args, "-o", libexec"bin", ".cmdllgo"

    libexec.install "LICENSE", "README.md"

    path = llvm.opt_bin + ":" + %w[go pkgconf].map { |f| Formula[f].opt_bin }.join(":")
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

    (testpath"hello.go").write <<~GO
      package main

      import "github.comgoplusllgoc"

      func main() {
        c.Printf(c.Str("Hello LLGO\\n"))
      }
    GO
    (testpath"go.mod").write <<~GOMOD
      module hello
    GOMOD
    system Formula["go"].opt_bin"go", "get", "github.comgoplusllgo@v#{version}"
    system bin"llgo", "build", "-o", "hello", "."
    assert_equal "Hello LLGO\n", shell_output(".hello")
  end
end