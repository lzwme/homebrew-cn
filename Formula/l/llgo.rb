class Llgo < Formula
  desc "Go compiler based on LLVM integrate with the C ecosystem and Python"
  homepage "https:github.comgoplusllgo"
  url "https:github.comgoplusllgoarchiverefstagsv0.9.5.tar.gz"
  sha256 "476f699477578af75793475c8b57d491e9fa538933139a0ab99040549b242648"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "12bf8abb5ae2c3a49056805aae76d4b300e4253230d22d9b3fb1d53c1a879cb8"
    sha256 cellar: :any, arm64_ventura:  "8c0903327b85d1fab75d3ce09667c657fe446110ae7c62a0fa567e27c1b1a43a"
    sha256 cellar: :any, arm64_monterey: "ba68c8e8fd5bafc383971864e144d9ae6cd290c579787f9e8bd6c80ce3d23a8b"
    sha256 cellar: :any, sonoma:         "c855df8a38f7a1482270dcdde42d3939876010e92bb814126bde7a69fc3fc22b"
    sha256 cellar: :any, ventura:        "77281d19421962aea10d3876c028f3fdbdb4bbb437312bb43a83189c4d3a1ad0"
    sha256 cellar: :any, monterey:       "c4c20296cd7037a82c7a8122c8eb42e5f0e2ac47e785bfe67d7e729244814a65"
    sha256               x86_64_linux:   "b076791d77438e3c1ff43f98d1e7a14d3787dc00beed71bbf171255f5dbc7e9d"
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