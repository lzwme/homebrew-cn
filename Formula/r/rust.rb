class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"
  license any_of: ["Apache-2.0", "MIT"]

  stable do
    url "https://static.rust-lang.org/dist/rustc-1.90.0-src.tar.gz"
    sha256 "799a9f9cba4ed5351e071048bcf6b5560755d9009648def33a407dd4961f9b7e"

    # From https://github.com/rust-lang/rust/tree/#{version}/src/tools
    resource "cargo" do
      url "https://ghfast.top/https://github.com/rust-lang/cargo/archive/refs/tags/0.91.0.tar.gz"
      sha256 "d3d3f0ed975c00b3955a73fbf67bcfb4b318b49fde7c584c89477a382cdba5b3"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cf848c05a4c652ecf2760bdafde69f9ae6cffe94be351dab5fc6345ba9bec090"
    sha256 cellar: :any,                 arm64_sequoia: "a266c069c994d8696b4f6fadb3250ae0bbab952c42e0d2862d203bb9295e8078"
    sha256 cellar: :any,                 arm64_sonoma:  "de6f3f4cd9493d998dfa29a93e784fa62685755dffcf6c63a968b95cd82451df"
    sha256 cellar: :any,                 sonoma:        "f87879df512e7233ad09f70fcbf35538e67758fb3e0d24b156b680aa7c45e6b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79cdb42ebef9c6466304d5de24a47350dde7f57c5767b57d595621b8b20c8d38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35110dc77744b66b32494460bbce1d5ffe08727267601c45e3f83d1b3d511351"
  end

  head do
    url "https://github.com/rust-lang/rust.git", branch: "master"

    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git", branch: "master"
    end
  end

  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "llvm"
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
        url "https://static.rust-lang.org/dist/2025-08-07/rustc-1.89.0-aarch64-apple-darwin.tar.xz", using: :nounzip
        sha256 "6d2cf6164bef00ff3d2c37ca0a0658ffb7c9c3178882a72d78e35abeba888860"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2025-08-07/rustc-1.89.0-x86_64-apple-darwin.tar.xz", using: :nounzip
        sha256 "04f3acf7ddfb998fa2713226fd8528e6157b9030f9a6ac6678133d82d5c099f9"
      end
    end

    on_linux do
      on_arm do
        url "https://static.rust-lang.org/dist/2025-08-07/rustc-1.89.0-aarch64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "16ed8d8c7628a481c8501e7cd1022a123269b297bdedbb7f211f37a15e937e0e"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2025-08-07/rustc-1.89.0-x86_64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "b42c254e1349df86bd40bc28fdf386172a1a46f2eeabe3c7a08a75cf1fb60e27"
      end
    end
  end

  # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0
  resource "cargo-bootstrap" do
    on_macos do
      on_arm do
        url "https://static.rust-lang.org/dist/2025-08-07/cargo-1.89.0-aarch64-apple-darwin.tar.xz", using: :nounzip
        sha256 "545517d16ac76789aa6ce801cbc3eeecc9acaf43f3ccb63148c3577f2bb4b8d3"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2025-08-07/cargo-1.89.0-x86_64-apple-darwin.tar.xz", using: :nounzip
        sha256 "81fabf0d783af844c7dd74dfe10d0302dd063775789a914f29b33e3d46ee1cf0"
      end
    end

    on_linux do
      on_arm do
        url "https://static.rust-lang.org/dist/2025-08-07/cargo-1.89.0-aarch64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "f9df3ee6d55a2387459b843477743fa386c3c0f126bd0be01691ee49309681b8"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2025-08-07/cargo-1.89.0-x86_64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "99fc10be2aeedf2c23a484f217bfa76458494495a0eee33e280d3616bb08282d"
      end
    end
  end

  # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0
  resource "rust-std-bootstrap" do
    on_macos do
      on_arm do
        url "https://static.rust-lang.org/dist/2025-08-07/rust-std-1.89.0-aarch64-apple-darwin.tar.xz", using: :nounzip
        sha256 "1f729f8ba21725618ab894f14cc38f01470f1d15ea76a81fac2da63291bed75c"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2025-08-07/rust-std-1.89.0-x86_64-apple-darwin.tar.xz", using: :nounzip
        sha256 "09780642e83b12085500ea78dcb46112a546467352cc4a4dd229f22e03d4a5f0"
      end
    end

    on_linux do
      on_arm do
        url "https://static.rust-lang.org/dist/2025-08-07/rust-std-1.89.0-aarch64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "abea0955dded88c68d731524ab9d29b162fae23bf5805b9f1dec063cba37c2aa"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2025-08-07/rust-std-1.89.0-x86_64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "2719470dcd78b3f97d78b978c8f85a1a58d84ff11b62558294621c01bca34d49"
      end
    end
  end

  def llvm
    Formula["llvm"]
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