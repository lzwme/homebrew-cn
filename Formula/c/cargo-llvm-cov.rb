class CargoLlvmCov < Formula
  desc "Cargo subcommand to easily use LLVM source-based code coverage"
  homepage "https:github.comtaiki-ecargo-llvm-cov"
  # cannot use github tarball due to https:github.comtaiki-ecargo-llvm-covpull152#issuecomment-1107055622
  url "https:static.crates.iocratescargo-llvm-covcargo-llvm-cov-0.6.3.crate"
  sha256 "4f0b790268b2d6e55587c7c3ae694181f6103e82efd7ee8cdfc2648cbb6a6dbe"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comtaiki-ecargo-llvm-cov.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9b1f948098dd967729dc2ef248fc89c23b9c17f4ec0aa5e72871c864c336b3c9"
    sha256 cellar: :any,                 arm64_ventura:  "4af9536920d22d1c46e4eb19b88d99f4d570ad40979082f0cdbf8368d099e187"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60770eb32d94a9aca7a10fe4927d36af7c9f103958f5b8ed84a1d4914f00599a"
    sha256 cellar: :any,                 sonoma:         "79a211142131635c73c34da36693c8b73e40dfc5222463b7dcc22d9ce8e596eb"
    sha256 cellar: :any,                 ventura:        "dc3a9359a6e4ae7a2b65c887cac9037761db222ed25daba1441c1bc928b234f4"
    sha256 cellar: :any_skip_relocation, monterey:       "55c56758b1537b62478eae286defb0617a41d2af512aa9bd534e2e070c609af1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca66406366975b0fb1d67dfd1776ba87ed6025a80c7944308caea8d09ca7035a"
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