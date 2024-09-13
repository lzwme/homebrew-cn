class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https:www.rust-lang.org"
  license any_of: ["Apache-2.0", "MIT"]

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
    sha256 cellar: :any,                 arm64_sequoia:  "976612b55f2634f28d7ecd00253fab4cd179b352ed5e998c862de2d193690a34"
    sha256 cellar: :any,                 arm64_sonoma:   "e435ab78fdd28d1d422cfb2fc053e56fd4d529b284ff2546e8fe30aacc183712"
    sha256 cellar: :any,                 arm64_ventura:  "567f85fc6853432ce4bcbd3a336067a2544b59c2b9a17272a1afa8aecd8fa873"
    sha256 cellar: :any,                 arm64_monterey: "00cd15f19928821fbb8fa658f6bc54118e8b8871eaeee8245dcc1d87d8cc0e27"
    sha256 cellar: :any,                 sonoma:         "62353b21e9ffd4ff946fbaedc91b796985172379b8eaf77eebe39859b0dea31d"
    sha256 cellar: :any,                 ventura:        "3ac85eed3480bd7d2da271e68013f30b1e44376e9cd468ac86f3fb90e6b0cbf2"
    sha256 cellar: :any,                 monterey:       "1768b11223edc7a14d22fdbe07365422112dd7af21a4b520df2a92068425cd87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01f58715374b8362b17d665beb02f74a2f9ec40e4451eae91a88b04776ae3511"
  end

  head do
    url "https:github.comrust-langrust.git", branch: "master"

    resource "cargo" do
      url "https:github.comrust-langcargo.git", branch: "master"
    end
  end

  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "llvm"
  depends_on macos: :sierra
  depends_on "openssl@3"
  depends_on "pkg-config"
  depends_on "zstd"

  uses_from_macos "python" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

  link_overwrite "etcbash_completion.dcargo"

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

    # rustfmt and rust-analyzer are available in their own formulae.
    tools = %w[
      analysis
      cargo
      clippy
      rustdoc
      rust-analyzer-proc-macro-srv
      rust-demangler
      src
    ]
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --tools=#{tools.join(",")}
      --llvm-root=#{Formula["llvm"].opt_prefix}
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