class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"
  license any_of: ["Apache-2.0", "MIT"]
  revision 2

  stable do
    url "https://static.rust-lang.org/dist/rustc-1.89.0-src.tar.gz"
    sha256 "2576f9f440dd99b0151bd28f59aa0ac6102d5c4f3ed4ef8a810c8dd05057250d"

    # From https://github.com/rust-lang/rust/tree/#{version}/src/tools
    resource "cargo" do
      url "https://ghfast.top/https://github.com/rust-lang/cargo/archive/refs/tags/0.90.0.tar.gz"
      sha256 "6e38bf4131c667b41b8a5b78bc39232ece2d476a75de1f72f82ce07f425b2e3b"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8988880d5519ccbad2f8d4195e6b10b573b23644193ff7f247dff00814ef3b7b"
    sha256 cellar: :any,                 arm64_sonoma:  "89895e5bcbff0ea562cfca738c6bd76c6510222d072dcaf70e81dadf08fe15fe"
    sha256 cellar: :any,                 arm64_ventura: "6295c25c66d8ca5922596ee299e489417d6795be3c0a090bc0a4fd09487dc941"
    sha256 cellar: :any,                 sonoma:        "4ecc32ddf37cf27abb96584e8e44342795302eff52f578146057c2af3d583ef9"
    sha256 cellar: :any,                 ventura:       "b03d69b976b4cae4b66da008ba282bace32a4f224617979ff3d5c830e175c2cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65e4e3f9a25338bec5097e85712ce1a7a473f11b39a06dd79d9ae6b2ea681f1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffb7d70528c835532b387211b2133e95c13c22c5e06f2f10989f0b9bbfea76bd"
  end

  head do
    url "https://github.com/rust-lang/rust.git", branch: "master"

    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git", branch: "master"
    end
  end

  depends_on "libgit2"
  depends_on "libssh2"
  # Don't bump to LLVM 21 until this is fixed:
  # https://github.com/llvm/llvm-project/issues/155998
  depends_on "llvm@20"
  depends_on macos: :sierra
  depends_on "openssl@3"
  depends_on "pkgconf"
  depends_on "zstd"

  uses_from_macos "python" => :build
  uses_from_macos "curl"

  link_overwrite "etc/bash_completion.d/cargo"
  # These used to belong in `rustfmt`.
  link_overwrite "bin/cargo-fmt", "bin/git-rustfmt", "bin/rustfmt", "bin/rustfmt-*"

  # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0
  resource "rustc-bootstrap" do
    on_macos do
      on_arm do
        url "https://static.rust-lang.org/dist/2025-06-26/rustc-1.88.0-aarch64-apple-darwin.tar.xz", using: :nounzip
        sha256 "249f4cacd3fac1f718af19373c73e9d3b9a595965972d8b1f3947c578110f520"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2025-06-26/rustc-1.88.0-x86_64-apple-darwin.tar.xz", using: :nounzip
        sha256 "c8f1ea4fc3e507c8e733809bd3ad91a00f5b209d85620be9013bea5f97f31f24"
      end
    end

    on_linux do
      on_arm do
        url "https://static.rust-lang.org/dist/2025-06-26/rustc-1.88.0-aarch64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "b841d40bb98b2718c6452ec8421a4a8df584fce8d41875bcd9b1af83f52f7d96"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2025-06-26/rustc-1.88.0-x86_64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "b049fd57fce274d10013e2cf0e05f215f68f6580865abc52178f66ae9bf43fd8"
      end
    end
  end

  # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0
  resource "cargo-bootstrap" do
    on_macos do
      on_arm do
        url "https://static.rust-lang.org/dist/2025-06-26/cargo-1.88.0-aarch64-apple-darwin.tar.xz", using: :nounzip
        sha256 "71c08c8fab9b7a9cd13b6119886d50ce48efa8261d08e1fd328ed3ee1c84e2e0"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2025-06-26/cargo-1.88.0-x86_64-apple-darwin.tar.xz", using: :nounzip
        sha256 "e7f672132591df180b58f8e7af875e1971a10fe71243f7d84f9b3f6742f998bc"
      end
    end

    on_linux do
      on_arm do
        url "https://static.rust-lang.org/dist/2025-06-26/cargo-1.88.0-aarch64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "5aa43865f2002914ce4fca8916b4403bfca62f17e779ad368f6a17553296a58b"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2025-06-26/cargo-1.88.0-x86_64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "856962610ee821648cee32e3d6abac667af7bb7ea6ec6f3d184cc31e66044f6b"
      end
    end
  end

  # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0
  resource "rust-std-bootstrap" do
    on_macos do
      on_arm do
        url "https://static.rust-lang.org/dist/2025-06-26/rust-std-1.88.0-aarch64-apple-darwin.tar.xz", using: :nounzip
        sha256 "532be07511af557cb67f33bfc77044a787363ab281b963752542bc837ce90e96"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2025-06-26/rust-std-1.88.0-x86_64-apple-darwin.tar.xz", using: :nounzip
        sha256 "2570350a6651e60a2fe0aa438be5cd123ed3543b4b44c916284ff7e7e331d16a"
      end
    end

    on_linux do
      on_arm do
        url "https://static.rust-lang.org/dist/2025-06-26/rust-std-1.88.0-aarch64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "e9ac4ff3c87247a2195fcceddbf1bdeee5c4fd337f014d8f4c4e3ac99002021f"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2025-06-26/rust-std-1.88.0-x86_64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "36d7eacf46bd5199cb433e49a9ed9c9b380d82f8a0ebc05e89b43b51c070c955"
      end
    end
  end

  def llvm
    Formula["llvm@20"]
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://docs.rs/openssl/latest/openssl/#manual
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"

    if OS.mac?
      # Requires the CLT to be the active developer directory if Xcode is installed
      ENV["SDKROOT"] = MacOS.sdk_path
      # Fix build failure for compiler_builtins "error: invalid deployment target
      # for -stdlib=libc++ (requires OS X 10.7 or later)"
      ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version
    end

    cargo_src_path = buildpath/"src/tools/cargo"
    rm_r(cargo_src_path)
    resource("cargo").stage cargo_src_path
    if OS.mac?
      inreplace cargo_src_path/"Cargo.toml",
                /^curl\s*=\s*"(.+)"$/,
                'curl = { version = "\\1", features = ["force-system-lib-on-osx"] }'
    end

    cache_date = File.basename(File.dirname(resource("rustc-bootstrap").url))
    build_cache_directory = buildpath/"build/cache"/cache_date

    resource("rustc-bootstrap").stage build_cache_directory
    resource("cargo-bootstrap").stage build_cache_directory
    resource("rust-std-bootstrap").stage build_cache_directory

    # rust-analyzer is available in its own formula.
    tools = %w[
      analysis
      cargo
      clippy
      rustdoc
      rustfmt
      rust-analyzer-proc-macro-srv
      rust-demangler
      src
    ]
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --tools=#{tools.join(",")}
      --llvm-root=#{llvm.opt_prefix}
      --enable-llvm-link-shared
      --enable-profiler
      --enable-vendor
      --disable-cargo-native-static
      --disable-docs
      --disable-lld
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

    bash_completion.install etc/"bash_completion.d/cargo"
    (lib/"rustlib/src/rust").install "library"
    rm([
      bin.glob("*.old"),
      lib/"rustlib/install.log",
      lib/"rustlib/uninstall.sh",
      (lib/"rustlib").glob("manifest-*"),
    ])
  end

  def post_install
    lib.glob("rustlib/**/*.dylib") do |dylib|
      chmod 0664, dylib
      MachO::Tools.change_dylib_id(dylib, "@rpath/#{File.basename(dylib)}")
      MachO.codesign!(dylib) if Hardware::CPU.arm?
      chmod 0444, dylib
    end
    return unless OS.mac?

    # Symlink our LLVM here to make sure the adjacent bin/rust-* tools can find it.
    # Needs to be done in `postinstall` to avoid having `change_dylib_id` done on it.
    lib.glob("rustlib/*/lib") do |dir|
      # Use `ln_sf` instead of `install_symlink` to avoid resolving this into a Cellar path.
      ln_sf llvm.opt_lib/shared_library("libLLVM"), dir
    end
  end

  def caveats
    <<~EOS
      Link this toolchain with `rustup` under the name `system` with:
        rustup toolchain link system "$(brew --prefix rust)"

      If you use rustup, avoid PATH conflicts by following instructions in:
        brew info rustup
    EOS
  end

  test do
    require "utils/linkage"

    system bin/"rustdoc", "-h"
    (testpath/"hello.rs").write <<~RUST
      fn main() {
        println!("Hello World!");
      }
    RUST
    system bin/"rustc", "hello.rs"
    assert_equal "Hello World!\n", shell_output("./hello")
    system bin/"cargo", "new", "hello_world", "--bin"
    assert_equal "Hello, world!", cd("hello_world") { shell_output("#{bin}/cargo run").split("\n").last }

    assert_match <<~EOS, shell_output("#{bin}/rustfmt --check hello.rs", 1)
       fn main() {
      -  println!("Hello World!");
      +    println!("Hello World!");
       }
    EOS

    # We only check the tools' linkage here. No need to check rustc.
    expected_linkage = {
      bin/"cargo" => [
        Formula["libgit2"].opt_lib/shared_library("libgit2"),
        Formula["libssh2"].opt_lib/shared_library("libssh2"),
        Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
        Formula["openssl@3"].opt_lib/shared_library("libssl"),
      ],
    }
    unless OS.mac?
      expected_linkage[bin/"cargo"] += [
        Formula["curl"].opt_lib/shared_library("libcurl"),
      ]
    end
    missing_linkage = []
    expected_linkage.each do |binary, dylibs|
      dylibs.each do |dylib|
        next if Utils.binary_linked_to_library?(binary, dylib)

        missing_linkage << "#{binary} => #{dylib}"
      end
    end
    assert missing_linkage.empty?, "Missing linkage: #{missing_linkage.join(", ")}"
  end
end