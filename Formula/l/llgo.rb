class Llgo < Formula
  desc "Go compiler based on LLVM integrate with the C ecosystem and Python"
  homepage "https:github.comgoplusllgo"
  url "https:github.comgoplusllgoarchiverefstagsv0.9.1.tar.gz"
  sha256 "4298c0670d088db0faab6aa8bd1b3649d09ba1cf75c0e02171a446f6cd3fc1dd"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_sonoma:   "8294041a96e4228053933ecbc4bd9a0acbdb37cae9818777d5a920018bb41ef0"
    sha256 cellar: :any, arm64_ventura:  "76b026771d3a0730f813ae5aba9a58a2a551068cdf6581b4c1d76aac8f7d3301"
    sha256 cellar: :any, arm64_monterey: "262d54fd59104c3e8fc0e5950b0c476ab8dd834637561f2bc26fa5946622ac6e"
    sha256 cellar: :any, sonoma:         "e64d222a7bed11b2e019a5fc7409d49e0ef15cbb907a9e7c26688678e4a9d796"
    sha256 cellar: :any, ventura:        "d67e679cad8870d1c57e3ffd863592f916f78549271637f8fa8ec0552776185d"
    sha256 cellar: :any, monterey:       "383e0f0e2cd6a2d2070f467b5867a75212eb0977265fc247bc6ac4312c2f274e"
    sha256               x86_64_linux:   "c63c792e00e88f86a79fbf46f718782d9b7c8a608d737c4e23b03877fc7b67a1"
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