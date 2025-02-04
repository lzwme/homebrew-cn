class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https:www.rust-lang.org"
  license any_of: ["Apache-2.0", "MIT"]

  stable do
    url "https:static.rust-lang.orgdistrustc-1.84.1-src.tar.gz"
    sha256 "5e2fb5d49628a549f7671b2ccf9855ab379fd442831a7c2af16e0cdcc31bb375"

    # From https:github.comrust-langrusttree#{version}srctools
    resource "cargo" do
      url "https:github.comrust-langcargoarchiverefstags0.85.0.tar.gz"
      sha256 "5e708627470d41be5d615b0f064d5cbe40509cab62e751a2876936fb53ca0bcd"
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "6fe0e14f08adae82662551b478fdfaeb87f516be7762c60d28203e830c5caa91"
    sha256 cellar: :any,                 arm64_sonoma:  "ded9d66d7a87295fe9570cec1ce54814068aa3fc000d26a5d9e509e6cdf6be62"
    sha256 cellar: :any,                 arm64_ventura: "3a96ac743681822906e48f4bb8f481c78cc7823ebff3db20c41cdc35cb8fab91"
    sha256 cellar: :any,                 sonoma:        "7af190ff67405820a8e48e3a00613414d5918944305c6b760584322a21b8d740"
    sha256 cellar: :any,                 ventura:       "ca6593daae0d01d89d6f57762311bac3313aa8182ade7d79549b0d8d84c97809"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14875a6dce2f6ae3d1e2e8d0d1a27bb3e24990e3feef0776c4eb33e6497a0a9a"
  end

  head do
    url "https:github.comrust-langrust.git", branch: "master"

    resource "cargo" do
      url "https:github.comrust-langcargo.git", branch: "master"
    end
  end

  depends_on "libgit2@1.8" # upstream issue, https:github.comrust-langcargoissues15043
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
        url "https:static.rust-lang.orgdist2024-11-28rustc-1.83.0-aarch64-apple-darwin.tar.xz", using: :nounzip
        sha256 "7a55f65f1ab39f538c31f006e20350362251609af02d2156fc78823419aa2b10"
      end
      on_intel do
        url "https:static.rust-lang.orgdist2024-11-28rustc-1.83.0-x86_64-apple-darwin.tar.xz", using: :nounzip
        sha256 "9f951f40a1843298bc068a4f328a6869819a84bf0d55e943166d1b862b99af93"
      end
    end

    on_linux do
      on_arm do
        url "https:static.rust-lang.orgdist2024-11-28rustc-1.83.0-aarch64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "aa5d075f9903682e5171f359948717d32911bed8c39e0395042e625652062ea9"
      end
      on_intel do
        url "https:static.rust-lang.orgdist2024-11-28rustc-1.83.0-x86_64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "6ec40e0405c8cbed3b786a97d374c144b012fc831b7c22b535f8ecb524f495ad"
      end
    end
  end

  # From https:github.comrust-langrustblob#{version}srcstage0
  resource "cargo-bootstrap" do
    on_macos do
      on_arm do
        url "https:static.rust-lang.orgdist2024-11-28cargo-1.83.0-aarch64-apple-darwin.tar.xz", using: :nounzip
        sha256 "42a797429e7f7ac6e6c87c29845fe5face5b694a49b5026c63aed58726181536"
      end
      on_intel do
        url "https:static.rust-lang.orgdist2024-11-28cargo-1.83.0-x86_64-apple-darwin.tar.xz", using: :nounzip
        sha256 "ca303bdc840b643aa8905892b14a3ac3fb760e10c7fd87190403ced32412bec3"
      end
    end

    on_linux do
      on_arm do
        url "https:static.rust-lang.orgdist2024-11-28cargo-1.83.0-aarch64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "5b96aba48790acfacea60a6643a4f30d7edc13e9189ad36b41bbacdad13d49e1"
      end
      on_intel do
        url "https:static.rust-lang.orgdist2024-11-28cargo-1.83.0-x86_64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "de834a4062d9cd200f8e0cdca894c0b98afe26f1396d80765df828880a39b98c"
      end
    end
  end

  # From https:github.comrust-langrustblob#{version}srcstage0
  resource "rust-std-bootstrap" do
    on_macos do
      on_arm do
        url "https:static.rust-lang.orgdist2024-11-28rust-std-1.83.0-aarch64-apple-darwin.tar.xz", using: :nounzip
        sha256 "635230a14210e87b82c6f7f0597349c5cb9e5ee3a260c9b049b4b078af72eae1"
      end
      on_intel do
        url "https:static.rust-lang.orgdist2024-11-28rust-std-1.83.0-x86_64-apple-darwin.tar.xz", using: :nounzip
        sha256 "9562c98c59c6344f53a4f4c331e34cc88975153b8c25dd8b7a11ce00077ee3cb"
      end
    end

    on_linux do
      on_arm do
        url "https:static.rust-lang.orgdist2024-11-28rust-std-1.83.0-aarch64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "8804f673809c5c3db11ba354b5cf9724aed68884771fa32af4b3472127a76028"
      end
      on_intel do
        url "https:static.rust-lang.orgdist2024-11-28rust-std-1.83.0-x86_64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "c88fe6cb22f9d2721f26430b6bdd291e562da759e8629e2b4c7eb2c7cad705f2"
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

  test do
    require "utilslinkage"

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
        next if Utils.binary_linked_to_library?(binary, dylib)

        missing_linkage << "#{binary} => #{dylib}"
      end
    end
    assert missing_linkage.empty?, "Missing linkage: #{missing_linkage.join(", ")}"
  end
end