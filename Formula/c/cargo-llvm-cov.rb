class CargoLlvmCov < Formula
  desc "Cargo subcommand to easily use LLVM source-based code coverage"
  homepage "https:github.comtaiki-ecargo-llvm-cov"
  # cannot use github tarball due to https:github.comtaiki-ecargo-llvm-covpull152#issuecomment-1107055622
  url "https:static.crates.iocratescargo-llvm-covcargo-llvm-cov-0.6.2.crate"
  sha256 "d42cf2e15cc7913e901a83494b7357a682231f9951915d0e94092a99fffdf5e1"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comtaiki-ecargo-llvm-cov.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ed698da562571c2f99f88a468fa498700810d56ee10032b980c0c6c063367d11"
    sha256 cellar: :any,                 arm64_ventura:  "7f8615577cfe30243d46f88aa197614c2d78d1ebcee8ddde207ea7eb95ab9191"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ae0debaac3859546ab106a9592e02460f4c0a806b65a667b51df951cdb6ae50"
    sha256 cellar: :any,                 sonoma:         "94886371a77a53d1fd6e5c277f44c91e973595e19236a98a393a49e38c3115f6"
    sha256 cellar: :any,                 ventura:        "389802f8e04fec685dec7fe05d27460cd5a15bc715e61540e78bd9d56f23adb8"
    sha256 cellar: :any_skip_relocation, monterey:       "f4f47046abbea6abee72fb757ed155a650259c1817f93fa4f2988817be81eabb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07e9163e18d204384107e0a2750ec126b486c86569f71c1105fc65166697605d"
  end

  depends_on "rust" => :build
  depends_on "rustup-init" => :test
  depends_on "llvm"

  def install
    system "tar", "--strip-components", "1", "-xzvf", "cargo-llvm-cov-#{version}.crate" unless build.head?
    system "cargo", "install", *std_cargo_args(root: libexec)
    llvm_bin = Formula["llvm"].opt_bin
    (bin"cargo-llvm-cov").write_env_script libexec"bincargo-llvm-cov",
      LLVM_COV:      llvm_bin"llvm-cov",
      LLVM_PROFDATA: llvm_bin"llvm-profdata"
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https:github.comHomebrewhomebrew-corepull134074#pullrequestreview-1484979359
    ENV["RUSTUP_INIT_SKIP_PATH_CHECK"] = "yes"
    rustup_init = Formula["rustup-init"].bin"rustup-init"
    system rustup_init, "-y", "--profile", "minimal", "--default-toolchain", "beta", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE"cargo_cachebin"

    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      system "cargo", "llvm-cov", "--html"
    end
    assert_predicate testpath"hello_worldtargetllvm-covhtmlindex.html", :exist?
  end
end