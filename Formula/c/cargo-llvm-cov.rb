class CargoLlvmCov < Formula
  desc "Cargo subcommand to easily use LLVM source-based code coverage"
  homepage "https:github.comtaiki-ecargo-llvm-cov"
  # cannot use github tarball due to https:github.comtaiki-ecargo-llvm-covpull152#issuecomment-1107055622
  url "https:static.crates.iocratescargo-llvm-covcargo-llvm-cov-0.6.12.crate"
  sha256 "6aae8e21e7bf0238826952065e4c5967578fbdbf2d3da58c4c8344b4be152e90"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comtaiki-ecargo-llvm-cov.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "17e47916d343c2b7daed8a0aba08ab0a1f4c3f2135394996e5c3f1818842bc62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0758a8a35bf78ee36ad11fef4bf2129c10effa17496c029d03720b4e99d4865e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5bb705276f86145b6e5f94e917e0dcecf401fbf179563ee77b170ba7a3266689"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e7833fb8029f12367716c2728b96dc4bfa1ac2e3296f8edc4fa215d9e35b82d"
    sha256 cellar: :any_skip_relocation, sonoma:         "12f457041ff8a46987ca6bcef198882a1dd9e73e9193ef8615c7c30c9dd72065"
    sha256 cellar: :any_skip_relocation, ventura:        "d156deda414570b3e48290081220088c9bebd2515754ff53afd6e1bc0b3212c2"
    sha256 cellar: :any_skip_relocation, monterey:       "414b9e7e4059df14deb474a9c4ef1f9280b9344e2818c42756d5b8b176b6d171"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7b62832734412e8339329492d0f8fc5cf328670c2f01aad1182f6a25d9998b5"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https:github.comHomebrewhomebrew-corepull134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"

    system "cargo", "new", "hello_world", "--lib"
    cd "hello_world" do
      system "cargo", "llvm-cov", "--html"
    end
    assert_predicate testpath"hello_worldtargetllvm-covhtmlindex.html", :exist?
  end
end