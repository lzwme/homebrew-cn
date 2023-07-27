class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"
  license any_of: ["Apache-2.0", "MIT"]

  stable do
    url "https://static.rust-lang.org/dist/rustc-1.71.0-src.tar.gz"
    sha256 "a667e4abdc5588ebfea35c381e319d840ffbf8d2dbfb79771730573642034c96"

    # From https://github.com/rust-lang/rust/tree/#{version}/src/tools
    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git",
          tag:      "0.72.0",
          revision: "cfd3bbd8fe4fd92074dfad04b7eb9a923646839f"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6d3c3af59119378b1834dd1e2a8305ed112495d57752c8121a316494879b32c9"
    sha256 cellar: :any,                 arm64_monterey: "e9129363c876ab1e895a4d43b4c5522a993311a0110b99ac98a4d33565ff5f91"
    sha256 cellar: :any,                 arm64_big_sur:  "e555d0975215ee1463f6054433ce46efd44df6ac24b764c943c7a6de63b9309e"
    sha256 cellar: :any,                 ventura:        "157c9336adb9c0610464e97c0e7a87e8befd311b5eef005baee4f23d06c217be"
    sha256 cellar: :any,                 monterey:       "4e8338719bd8480e7252fa8403588ce115707e863444b38d2f3efd0cc07aa5b3"
    sha256 cellar: :any,                 big_sur:        "8dd7e892b5626872be4c19fb7b9f17ea377e1217cc907bf343f4f32efd30f418"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91ba09bd1a47c20decf9540f1352ea49287b79106fc407074985536c48e5a03a"
  end

  head do
    url "https://github.com/rust-lang/rust.git", branch: "master"

    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git", branch: "master"
    end
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "python@3.11" => :build
  depends_on "openssl@3"
  depends_on "pkg-config"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  conflicts_with "rust-analyzer", because: "both install `rust-analyzer` binary"
  conflicts_with "rustfmt", because: "both install `cargo-fmt` and `rustfmt` binaries"

  resource "cargobootstrap" do
    on_macos do
      # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0.json
      on_arm do
        url "https://static.rust-lang.org/dist/2023-06-01/cargo-1.70.0-aarch64-apple-darwin.tar.xz"
        sha256 "faa0c57eab1846f4220e0833a167b845799bfc2d43aee819db7e9f5fe7d5a031"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2023-06-01/cargo-1.70.0-x86_64-apple-darwin.tar.xz"
        sha256 "0aa4661564be110614874812891d29b327eb343d2eb1eaf9862438aa2436f6b5"
      end
    end

    on_linux do
      # From: https://github.com/rust-lang/rust/blob/#{version}/src/stage0.json
      on_arm do
        url "https://static.rust-lang.org/dist/2023-06-01/cargo-1.70.0-aarch64-unknown-linux-gnu.tar.xz"
        sha256 "8fd2d9806f0601feab1485f79e46d1441af2158c68abf56788ff355d5c6b4ab5"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2023-06-01/cargo-1.70.0-x86_64-unknown-linux-gnu.tar.xz"
        sha256 "650e7a890a52869cd14e2305652bff775aec7fc2cf47fc62cf4a89ff07242333"
      end
    end
  end

  def install
    ENV.prepend_path "PATH", Formula["python@3.11"].opt_libexec/"bin"

    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    if OS.mac?
      # Requires the CLT to be the active developer directory if Xcode is installed
      ENV["SDKROOT"] = MacOS.sdk_path
      # Fix build failure for compiler_builtins "error: invalid deployment target
      # for -stdlib=libc++ (requires OS X 10.7 or later)"
      ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version
    end

    args = %W[--prefix=#{prefix} --enable-vendor --set rust.jemalloc]
    if build.head?
      args << "--disable-rpath"
      args << "--release-channel=nightly"
    else
      args << "--release-channel=stable"
    end

    system "./configure", *args
    system "make"
    system "make", "install"

    resource("cargobootstrap").stage do
      system "./install.sh", "--prefix=#{buildpath}/cargobootstrap"
    end
    ENV.prepend_path "PATH", buildpath/"cargobootstrap/bin"

    resource("cargo").stage do
      ENV["RUSTC"] = bin/"rustc"
      args = %W[--root #{prefix} --path . --force]
      args += %w[--features curl-sys/force-system-lib-on-osx] if OS.mac?
      system "cargo", "install", *args
      man1.install Dir["src/etc/man/*.1"]
      bash_completion.install "src/etc/cargo.bashcomp.sh"
      zsh_completion.install "src/etc/_cargo"
    end

    (lib/"rustlib/src/rust").install "library"
    rm_rf prefix/"lib/rustlib/uninstall.sh"
    rm_rf prefix/"lib/rustlib/install.log"
  end

  def post_install
    Dir["#{lib}/rustlib/**/*.dylib"].each do |dylib|
      chmod 0664, dylib
      MachO::Tools.change_dylib_id(dylib, "@rpath/#{File.basename(dylib)}")
      MachO.codesign!(dylib) if Hardware::CPU.arm?
      chmod 0444, dylib
    end
  end

  test do
    system bin/"rustdoc", "-h"
    (testpath/"hello.rs").write <<~EOS
      fn main() {
        println!("Hello World!");
      }
    EOS
    system bin/"rustc", "hello.rs"
    assert_equal "Hello World!\n", shell_output("./hello")
    system bin/"cargo", "new", "hello_world", "--bin"
    assert_equal "Hello, world!", cd("hello_world") { shell_output("#{bin}/cargo run").split("\n").last }
  end
end