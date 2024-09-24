class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https:www.rust-lang.org"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1

  stable do
    url "https:static.rust-lang.orgdistrustc-1.81.0-src.tar.gz"
    sha256 "872448febdff32e50c3c90a7e15f9bb2db131d13c588fe9071b0ed88837ccfa7"

    # From https:github.comrust-langrusttree#{version}srctools
    resource "cargo" do
      url "https:github.comrust-langcargoarchiverefstags0.82.0.tar.gz"
      sha256 "1c89e6a7a28dd78aca53227fd5e14340fcb7cb154ad9655a2f304b5687986cc3"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b4fb0882454f41c387466c0a96687703475b4a0708dba7bdc05aa0c2e9621c96"
    sha256 cellar: :any,                 arm64_sonoma:  "832b6fff80c5e0071049752764d8be9c31ce821ccb121d3e833c45c67ba9a74f"
    sha256 cellar: :any,                 arm64_ventura: "a4665458ecf6a676775858d854039c455fb6eb4055d31da491c367470314eccf"
    sha256 cellar: :any,                 sonoma:        "e2e2790090816a3b1f3b1ed3768590e375c353feb592e6b322d9d65799e1e6d8"
    sha256 cellar: :any,                 ventura:       "2bbe05da9d41ec5e0c57b03c612ef575bfd446c69d663db0d0d2e7f44c854374"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57f1e40fddfa6a38167c3f3a067724131b6a10172c552b21282d32219c1a8807"
  end

  head do
    url "https:github.comrust-langrust.git", branch: "master"

    resource "cargo" do
      url "https:github.comrust-langcargo.git", branch: "master"
    end
  end

  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "llvm@18"
  depends_on macos: :sierra
  depends_on "openssl@3"
  depends_on "pkg-config"
  depends_on "zstd"

  uses_from_macos "python" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

  link_overwrite "etcbash_completion.dcargo"
  # These used to belong in `rustfmt`.
  link_overwrite "bincargo-fmt", "bingit-rustfmt", "binrustfmt", "binrustfmt-*"

  # From https:github.comrust-langrustblob#{version}srcstage0
  resource "cargobootstrap" do
    on_macos do
      on_arm do
        url "https:static.rust-lang.orgdist2024-08-08rustc-1.80.1-aarch64-apple-darwin.tar.xz"
        sha256 "b22ac69b19de26fed67634379ae72cbc8fcc2ad1b1d97c4fbcb747264e69f13c"
      end
      on_intel do
        url "https:static.rust-lang.orgdist2024-08-08rustc-1.80.1-x86_64-apple-darwin.tar.xz"
        sha256 "72f7a04d1d283a24d76f1fe2317f7ec97daaeeb4010907ca5e7ef83790d94469"
      end
    end

    on_linux do
      on_arm do
        url "https:static.rust-lang.orgdist2024-08-08rustc-1.80.1-aarch64-unknown-linux-gnu.tar.xz"
        sha256 "fc21ca734504c3d0ccaf361f05cb491142c365ce8a326f942206b0199c49bbb4"
      end
      on_intel do
        url "https:static.rust-lang.orgdist2024-08-08rustc-1.80.1-x86_64-unknown-linux-gnu.tar.xz"
        sha256 "0367f069b49560af5c61810530d4721ad13eecfcb48952e67a2c32be903d5043"
      end
    end
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

    resource("cargobootstrap").stage do
      system ".install.sh", "--prefix=#{buildpath}cargobootstrap"
    end
    ENV.prepend_path "PATH", buildpath"cargobootstrapbin"

    cargo_src_path = buildpath"srctoolscargo"
    rm_r(cargo_src_path)
    resource("cargo").stage cargo_src_path
    if OS.mac?
      inreplace cargo_src_path"Cargo.toml",
                ^curl\s*=\s*"(.+)"$,
                'curl = { version = "\\1", features = ["force-system-lib-on-osx"] }'
    end

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
      --llvm-root=#{Formula["llvm@18"].opt_prefix}
      --enable-llvm-link-shared
      --enable-profiler
      --enable-vendor
      --disable-cargo-native-static
      --disable-docs
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
    Dir["#{lib}rustlib***.dylib"].each do |dylib|
      chmod 0664, dylib
      MachO::Tools.change_dylib_id(dylib, "@rpath#{File.basename(dylib)}")
      MachO.codesign!(dylib) if Hardware::CPU.arm?
      chmod 0444, dylib
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
    (testpath"hello.rs").write <<~EOS
      fn main() {
        println!("Hello World!");
      }
    EOS
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
        Formula["libgit2"].opt_libshared_library("libgit2"),
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