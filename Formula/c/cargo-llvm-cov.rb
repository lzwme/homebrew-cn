class CargoLlvmCov < Formula
  desc "Cargo subcommand to easily use LLVM source-based code coverage"
  homepage "https:github.comtaiki-ecargo-llvm-cov"
  # cannot use github tarball due to https:github.comtaiki-ecargo-llvm-covpull152#issuecomment-1107055622
  url "https:static.crates.iocratescargo-llvm-covcargo-llvm-cov-0.6.1.crate"
  sha256 "28c6c82de05671651362590905fab4560fbdfde3089dce475f5400b884b50ee7"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comtaiki-ecargo-llvm-cov.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "dcb12c636aaea914bfd7b0002eda7e119c1b664a7d74119276cb552f3c398de3"
    sha256 cellar: :any,                 arm64_ventura:  "feb3550393d845918b4b5c26fa9f8eb02328af8f01ec2a88918f7ad255e2ff3a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a1cd45275d534888140f302eea8cabdd4a9cc7d9772e470ba44e0e7d3bfe1ca"
    sha256 cellar: :any,                 sonoma:         "69026288903dbfd45e3f41525bd39c3c3b533bd2966bb58cfdd9e5b622a660b9"
    sha256 cellar: :any,                 ventura:        "2ea1317e43ef5bc0208d47e9c041821e613a9ec256001c56d9b4b689c6228d63"
    sha256 cellar: :any_skip_relocation, monterey:       "66e0045c0f6b248e85071d69dae54b5fe3ad94129db74ca251cb04dc0e80e1bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4422f53293cb28dc2c94151ac12209d2b0a521e930ee01221c2d8fc4f0c8252"
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