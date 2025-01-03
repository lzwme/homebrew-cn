class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https:www.rust-lang.org"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1

  stable do
    url "https:static.rust-lang.orgdistrustc-1.83.0-src.tar.gz"
    sha256 "722d773bd4eab2d828d7dd35b59f0b017ddf9a97ee2b46c1b7f7fac5c8841c6e"

    # From https:github.comrust-langrusttree#{version}srctools
    resource "cargo" do
      url "https:github.comrust-langcargoarchiverefstags0.84.0.tar.gz"
      sha256 "8d01b3cba1150ae34e5faec59894a9d4e9b46942b082f2bd4ed441ce417ed979"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c4ad4e7cca47cff44b33a0bd35f45b04c6a07e0e7541507f2d9151b02c91d296"
    sha256 cellar: :any,                 arm64_sonoma:  "e33c46cff673b5e03959f2a50a721219ca899a0867c569c8680ab966378420a6"
    sha256 cellar: :any,                 arm64_ventura: "bdd7fecbb17340264a9a01cc2a82be770c9d789eb6a9b2fe2770e82befd38510"
    sha256 cellar: :any,                 sonoma:        "7c8dbe22159b0e4f4402ed804cc27618d225ffecf40bac6bfc1ac44dbdf49b70"
    sha256 cellar: :any,                 ventura:       "7ab5ebb3f28faf78faeac4a55433a6ac52a9b1898f97c5151ce270b77ed119e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7776fa4c5f4e94c603f868e8209daee047bb56caccf98249db57f9ce5dfb296d"
  end

  head do
    url "https:github.comrust-langrust.git", branch: "master"

    resource "cargo" do
      url "https:github.comrust-langcargo.git", branch: "master"
    end
  end

  depends_on "libgit2@1.8" # needs https:github.comrust-langgit2-rsissues1109 to support libgit2 1.9
  depends_on "libssh2"
  depends_on "llvm"
  depends_on macos: :sierra
  depends_on "openssl@3"
  depends_on "pkgconf"
  depends_on "zstd"

  uses_from_macos "python" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

  link_overwrite "etcbash_completion.dcargo"
  # These used to belong in `rustfmt`.
  link_overwrite "bincargo-fmt", "bingit-rustfmt", "binrustfmt", "binrustfmt-*"

  # From https:github.comrust-langrustblob#{version}srcstage0
  resource "rustc-bootstrap" do
    on_macos do
      on_arm do
        url "https:static.rust-lang.orgdist2024-10-17rustc-1.82.0-aarch64-apple-darwin.tar.xz", using: :nounzip
        sha256 "ca9b9cab552c86ac7a28d8fb757c95a363bb5d6413b854b19472950eab2a9fa4"
      end
      on_intel do
        url "https:static.rust-lang.orgdist2024-10-17rustc-1.82.0-x86_64-apple-darwin.tar.xz", using: :nounzip
        sha256 "f74ade16cc926a240208ec87d02dcb30f6bb29f9ce9b36479bca57a159e6d96b"
      end
    end

    on_linux do
      on_arm do
        url "https:static.rust-lang.orgdist2024-10-17rustc-1.82.0-aarch64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "2958e667202819f6ba1ea88a2a36d7b6a49aad7e460b79ebbb5cf9221b96f599"
      end
      on_intel do
        url "https:static.rust-lang.orgdist2024-10-17rustc-1.82.0-x86_64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "90b61494f5ccfd4d1ca9a5ce4a0af49a253ca435c701d9c44e3e44b5faf70cb8"
      end
    end
  end

  # From https:github.comrust-langrustblob#{version}srcstage0
  resource "cargo-bootstrap" do
    on_macos do
      on_arm do
        url "https:static.rust-lang.orgdist2024-10-17cargo-1.82.0-aarch64-apple-darwin.tar.xz", using: :nounzip
        sha256 "66b9acc4629a21896ebd96076016263461567b8faf4eb0b76d0a72614790f29a"
      end
      on_intel do
        url "https:static.rust-lang.orgdist2024-10-17cargo-1.82.0-x86_64-apple-darwin.tar.xz", using: :nounzip
        sha256 "29c43175bcdff3e21f82561ca930f80661136b9aeffbfa6914667992362caad8"
      end
    end

    on_linux do
      on_arm do
        url "https:static.rust-lang.orgdist2024-10-17cargo-1.82.0-aarch64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "05c0d904a82cddb8a00b0bbdd276ad7e24dea62a7b6c380413ab1e5a4ed70a56"
      end
      on_intel do
        url "https:static.rust-lang.orgdist2024-10-17cargo-1.82.0-x86_64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "97aeae783874a932c4500f4d36473297945edf6294d63871784217d608718e70"
      end
    end
  end

  # From https:github.comrust-langrustblob#{version}srcstage0
  resource "rust-std-bootstrap" do
    on_macos do
      on_arm do
        url "https:static.rust-lang.orgdist2024-10-17rust-std-1.82.0-aarch64-apple-darwin.tar.xz", using: :nounzip
        sha256 "8b0786c55e02f3adc5df030861b6b60bc336326b9e372f6b1bf3040257621a90"
      end
      on_intel do
        url "https:static.rust-lang.orgdist2024-10-17rust-std-1.82.0-x86_64-apple-darwin.tar.xz", using: :nounzip
        sha256 "5e35d52cb3bd414fbe39f747e0080398f22eba06514c630e3a01e63417b4ca35"
      end
    end

    on_linux do
      on_arm do
        url "https:static.rust-lang.orgdist2024-10-17rust-std-1.82.0-aarch64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "1359ac1f3a123ae5da0ee9e47b98bb9e799578eefd9f347ff9bafd57a1d74a7f"
      end
      on_intel do
        url "https:static.rust-lang.orgdist2024-10-17rust-std-1.82.0-x86_64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "2eca3d36f7928f877c334909f35fe202fbcecce109ccf3b439284c2cb7849594"
      end
    end
  end

  def llvm
    Formula["llvm"]
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https:docs.rsopenssllatestopenssl#manual
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

    cargo_src_path = buildpath"srctoolscargo"
    rm_r(cargo_src_path)
    resource("cargo").stage cargo_src_path
    if OS.mac?
      inreplace cargo_src_path"Cargo.toml",
                ^curl\s*=\s*"(.+)"$,
                'curl = { version = "\\1", features = ["force-system-lib-on-osx"] }'
    end

    cache_date = File.basename(File.dirname(resource("rustc-bootstrap").url))
    build_cache_directory = buildpath"buildcache"cache_date

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

    system ".configure", *args
    system "make"
    system "make", "install"

    bash_completion.install etc"bash_completion.dcargo"
    (lib"rustlibsrcrust").install "library"
    rm([
      bin.glob("*.old"),
      lib"rustlibinstall.log",
      lib"rustlibuninstall.sh",
      (lib"rustlib").glob("manifest-*"),
    ])
  end

  def post_install
    lib.glob("rustlib***.dylib") do |dylib|
      chmod 0664, dylib
      MachO::Tools.change_dylib_id(dylib, "@rpath#{File.basename(dylib)}")
      MachO.codesign!(dylib) if Hardware::CPU.arm?
      chmod 0444, dylib
    end
    return unless OS.mac?

    # Symlink our LLVM here to make sure the adjacent binrust-lld can find it.
    # Needs to be done in `postinstall` to avoid having `change_dylib_id` done on it.
    lib.glob("rustlib*lib") do |dir|
      # Use `ln_sf` instead of `install_symlink` to avoid resolving this into a Cellar path.
      ln_sf llvm.opt_libshared_library("libLLVM"), dir
    end
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    system bin"rustdoc", "-h"
    (testpath"hello.rs").write <<~RUST
      fn main() {
        println!("Hello World!");
      }
    RUST
    system bin"rustc", "hello.rs"
    assert_equal "Hello World!\n", shell_output(".hello")
    system bin"cargo", "new", "hello_world", "--bin"
    assert_equal "Hello, world!", cd("hello_world") { shell_output("#{bin}cargo run").split("\n").last }

    assert_match <<~EOS, shell_output("#{bin}rustfmt --check hello.rs", 1)
       fn main() {
      -  println!("Hello World!");
      +    println!("Hello World!");
       }
    EOS

    # We only check the tools' linkage here. No need to check rustc.
    expected_linkage = {
      bin"cargo" => [
        Formula["libgit2@1.8"].opt_libshared_library("libgit2"),
        Formula["libssh2"].opt_libshared_library("libssh2"),
        Formula["openssl@3"].opt_libshared_library("libcrypto"),
        Formula["openssl@3"].opt_libshared_library("libssl"),
      ],
    }
    unless OS.mac?
      expected_linkage[bin"cargo"] += [
        Formula["curl"].opt_libshared_library("libcurl"),
        Formula["zlib"].opt_libshared_library("libz"),
      ]
    end
    missing_linkage = []
    expected_linkage.each do |binary, dylibs|
      dylibs.each do |dylib|
        next if check_binary_linkage(binary, dylib)

        missing_linkage << "#{binary} => #{dylib}"
      end
    end
    assert missing_linkage.empty?, "Missing linkage: #{missing_linkage.join(", ")}"
  end
end