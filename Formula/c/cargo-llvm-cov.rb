class CargoLlvmCov < Formula
  desc "Cargo subcommand to easily use LLVM source-based code coverage"
  homepage "https:github.comtaiki-ecargo-llvm-cov"
  # cannot use github tarball due to https:github.comtaiki-ecargo-llvm-covpull152#issuecomment-1107055622
  url "https:static.crates.iocratescargo-llvm-covcargo-llvm-cov-0.6.0.crate"
  sha256 "13d4feaa3eb1070f46c33e08a3d4949b3ebba143113f4cadb0effde0f30ddcf2"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comtaiki-ecargo-llvm-cov.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "54ff8d7c0d88ddeb469b2944223e9092b003f2ea6dbc864232ddcccfc9d473b6"
    sha256 cellar: :any,                 arm64_ventura:  "315f2db045ac56bf63c7ac56f87368e60eab1aa45cd8e867fdfd7bd82a38e055"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2d97f7660386c3068ef437fb30d3d21d081d1c08454961a27d0a42d707c76bf"
    sha256 cellar: :any,                 sonoma:         "ab15bceea7837c22f8f1e4b52c8707217f7d89b1240cf1b70177aec80bd20ec5"
    sha256 cellar: :any,                 ventura:        "42e580d5e07b53502f20e03895c30e79dd999890e9b916afb32587d633c1e025"
    sha256 cellar: :any_skip_relocation, monterey:       "f49139f7d0edea825a5483df068f5adac41d262cbd80e256e2f05ea21aa2319e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b720d81bd42d663542691c6fb6080ceb53c53b904458edfe11ccd7ff11ddda75"
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