class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"
  license any_of: ["Apache-2.0", "MIT"]

  stable do
    url "https://static.rust-lang.org/dist/rustc-1.72.0-src.tar.gz"
    sha256 "ea9d61bbb51d76b6ea681156f69f0e0596b59722f04414b01c6e100b4b5be3a1"

    # From https://github.com/rust-lang/rust/tree/#{version}/src/tools
    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git",
          tag:      "0.73.1",
          revision: "26bba48309d080ef3a3a00053f4e1dc879ef1de9"
    end

    # Fix for a compiler issue that may cause some builds to spin forever.
    # Remove on 1.73.0 release.
    # https://github.com/rust-lang/rust/pull/114948
    # https://github.com/rust-lang/rust/issues/115297
    # https://github.com/kpcyrd/sh4d0wup/issues/12
    patch do
      url "https://github.com/rust-lang/rust/commit/0f7f6b70617fbcda9f73755fa9b560bfb0a588eb.patch?full_index=1"
      sha256 "549f446612bef10a1a06a967f61655b59c1b6895d762d764ca89caf65c114fe9"
    end
  end

  bottle do
    sha256                               arm64_ventura:  "28e026c3d24f6dce2c1fb5087cf35cc5ffd88aa9055de215b81ae33d17e1f33b"
    sha256                               arm64_monterey: "9a1ee1b72f0e6c6a0c1aa4d44de57ad18616710233c18e1e24960b9219d448aa"
    sha256                               arm64_big_sur:  "7a65f06827c04b4d5ec27ff88efd143bc970081225eede6db71d2ce888ddf6ef"
    sha256                               ventura:        "dbc20ef5f433182b31d7b2bf0f2bb29c96abcf2ecf2cccfc00c9774b46c27038"
    sha256                               monterey:       "2a0ec660efed84e2ccfaaed4c30d2fc0577cbb9a41df32b374d8706202793837"
    sha256                               big_sur:        "daaa3f24643f928e4098dae014c9e2055057a05f4c12710b837991808c59b193"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1701167773a55ba430ef5c318cb951f38041387949aed7f37a43b909e78a607c"
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
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "llvm"
  depends_on "openssl@3"
  depends_on "pkg-config"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0.json
  resource "cargobootstrap" do
    on_macos do
      on_arm do
        url "https://static.rust-lang.org/dist/2023-07-13/cargo-1.71.0-aarch64-apple-darwin.tar.xz"
        sha256 "7637bc54d15cec656d7abb32417316546c7a784eded8677753b5dad7f05b5b09"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2023-07-13/cargo-1.71.0-x86_64-apple-darwin.tar.xz"
        sha256 "d83fe33cabf20394168f056ead44d243bd37dc96165d87867ea5114cfb52e739"
      end
    end

    on_linux do
      on_arm do
        url "https://static.rust-lang.org/dist/2023-07-13/cargo-1.71.0-aarch64-unknown-linux-gnu.tar.xz"
        sha256 "13e8ff23d6af976a45f3ab451bf698e318a8d1823d588ff8a989555096f894a8"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2023-07-13/cargo-1.71.0-x86_64-unknown-linux-gnu.tar.xz"
        sha256 "fe6fb520f59966300ee661d18b37c36cb3e614877c4c01dfedf987b8a9c577e9"
      end
    end
  end

  def install
    ENV.prepend_path "PATH", Formula["python@3.11"].opt_libexec/"bin"

    # Ensure that the `openssl` crate picks up the intended library.
    # https://docs.rs/openssl/latest/openssl/#manual
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    ENV["LIBGIT2_SYS_USE_PKG_CONFIG"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"

    if OS.mac?
      # Requires the CLT to be the active developer directory if Xcode is installed
      ENV["SDKROOT"] = MacOS.sdk_path
      # Fix build failure for compiler_builtins "error: invalid deployment target
      # for -stdlib=libc++ (requires OS X 10.7 or later)"
      ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version
    end

    resource("cargobootstrap").stage do
      system "./install.sh", "--prefix=#{buildpath}/cargobootstrap"
    end
    ENV.prepend_path "PATH", buildpath/"cargobootstrap/bin"

    cargo_src_path = buildpath/"src/tools/cargo"
    cargo_src_path.rmtree
    resource("cargo").stage cargo_src_path
    if OS.mac?
      inreplace cargo_src_path/"Cargo.toml",
                /^curl\s*=\s*"(.+)"$/,
                'curl = { version = "\\1", features = ["force-system-lib-on-osx"] }'
    end

    # rustfmt and rust-analyzer are available in their own formulae.
    tools = %w[
      analysis
      cargo
      clippy
      rustdoc
      rust-demangler
      src
    ]
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --tools=#{tools.join(",")}
      --llvm-root=#{Formula["llvm"].opt_prefix}
      --enable-llvm-link-shared
      --enable-vendor
      --disable-cargo-native-static
      --set=rust.jemalloc
      --release-description=#{tap.user}
    ]
    if build.head?
      args << "--disable-rpath"
      args << "--release-channel=nightly"
    else
      args << "--release-channel=stable"
    end

    system "./configure", *args
    system "make"
    system "make", "install"

    (lib/"rustlib/src/rust").install "library"
    rm_f [
      bin.glob("*.old"),
      lib/"rustlib/install.log",
      lib/"rustlib/uninstall.sh",
      (lib/"rustlib").glob("manifest-*"),
    ]
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