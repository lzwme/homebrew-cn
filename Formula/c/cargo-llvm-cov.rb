class CargoLlvmCov < Formula
  desc "Cargo subcommand to easily use LLVM source-based code coverage"
  homepage "https:github.comtaiki-ecargo-llvm-cov"
  # cannot use github tarball due to https:github.comtaiki-ecargo-llvm-covpull152#issuecomment-1107055622
  url "https:static.crates.iocratescargo-llvm-covcargo-llvm-cov-0.6.13.crate"
  sha256 "11afc9f40fc6468a1ed6c27effbe08f629e6eca5b95722fe9fa2eb93fbdb2ddf"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comtaiki-ecargo-llvm-cov.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f31761400b5c05e70bd09187afb632c49f242916f9e99aef3d2774ee07b331f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a51a4e719f4515b492454c4ed8dd3d78ecfe99e913e9e457544143925fae2929"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c2b54a183ee52275b0ee0ad5b5822e662076a26546fccfb17cdc029c97974ae9"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a4522648076c4511315888955ebdf641bfdab42ebf7844dc5d457984e0903b6"
    sha256 cellar: :any_skip_relocation, ventura:       "2d0587b07237d276bdedb2e9b029fc4469a773946d610086e1cd3f2b1d0827c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe7b8bbc4fa5629b6df6b91381c3ebd9fe7fba4a9ab76c88d8421f625fae8db8"
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