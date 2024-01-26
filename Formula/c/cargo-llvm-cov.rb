class CargoLlvmCov < Formula
  desc "Cargo subcommand to easily use LLVM source-based code coverage"
  homepage "https:github.comtaiki-ecargo-llvm-cov"
  # cannot use github tarball due to https:github.comtaiki-ecargo-llvm-covpull152#issuecomment-1107055622
  url "https:static.crates.iocratescargo-llvm-covcargo-llvm-cov-0.6.4.crate"
  sha256 "3911828fbd4ce2524edae92106d192faa8de5f629b383e0eb72f1eaec43ce777"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comtaiki-ecargo-llvm-cov.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7265e4dce4643b95b792b9d29b64644a3250abe1bc232b167ff8920718238237"
    sha256 cellar: :any,                 arm64_ventura:  "450382c3e8b5efaefa150b05f452c3b5261fd5b6811fec79e6d91ebdeff0114e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dca2bf4a6519f7c8a6ac9cb4fba8e2db1c836a6cca338d12ba3840bd10fca640"
    sha256 cellar: :any,                 sonoma:         "3a39b367d35c408ac530e9984590b7a202ed9cb9f673570c7f18c15d71445722"
    sha256 cellar: :any,                 ventura:        "99c7099606b86699f2640e14fe74475d20d7e8fc6d29198ae36e21de1c49cb80"
    sha256 cellar: :any_skip_relocation, monterey:       "ac902cd925e10931a0c17314a047a3cdc9c865f0e6dfe1e20cfd58599d42be31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9d40943c730df74a39311fc0d8ac7bd39aac3820a933420e11c0c626e2710c7"
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