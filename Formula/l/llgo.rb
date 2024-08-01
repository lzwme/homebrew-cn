class Llgo < Formula
  desc "Go compiler based on LLVM integrate with the C ecosystem and Python"
  homepage "https:github.comgoplusllgo"
  url "https:github.comgoplusllgoarchiverefstagsv0.9.4.tar.gz"
  sha256 "51fc0349b3d9230647f3bfac2dd7caef3b5cd8e7e1f8f22dcbc53d37403be0c7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "fc05893f5696e596a04f086e40a53ff2cb901560b5601e1a2a497ff817c7da6c"
    sha256 cellar: :any, arm64_ventura:  "e1e3142ff42869ba9344e3f746deee3016226fca8049f042020f23b8c6273860"
    sha256 cellar: :any, arm64_monterey: "bed1b23346e802e78b519ece498ce265bee9609c370d4dc966a2266ecffbd658"
    sha256 cellar: :any, sonoma:         "878039d2df8f54ea4ae175566774c1e4e9c51ba0bf60f697b4130d169c874300"
    sha256 cellar: :any, ventura:        "4898b2b60dfcc0d564e6f3c3b38535d75cf25200a825c4af1b0a2e9a42dbc6e8"
    sha256 cellar: :any, monterey:       "aaf096555745d97bdc9f9cb64fb037f317a8994a2b3d2bdf03327799b241b66b"
    sha256               x86_64_linux:   "97e07537487ad02a6ebcfb8ab263bfae3484a91bfbc8dc49646d299bda937841"
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