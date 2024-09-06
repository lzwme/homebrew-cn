class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https:www.rust-lang.org"
  license any_of: ["Apache-2.0", "MIT"]

  stable do
    url "https:static.rust-lang.orgdistrustc-1.80.1-src.tar.gz"
    sha256 "2c0b8f643942dcb810cbcc50f292564b1b6e44db5d5f45091153996df95d2dc4"

    # From https:github.comrust-langrusttree#{version}srctools
    resource "cargo" do
      url "https:github.comrust-langcargoarchiverefstags0.81.0.tar.gz"
      sha256 "5d2ea954f1a8bf03389fe2cefc5603de180a0c0010aa66628a325007216ef862"
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "27b8e4491b1bd94da25353f0e0e44fe2a133b586f57ecdd8751c898b0061c2aa"
    sha256 cellar: :any,                 arm64_ventura:  "2a89e8531353eedd6134ffbd6c29b1c0a8d6d9d52c05606d151c12b8de5c80ee"
    sha256 cellar: :any,                 arm64_monterey: "914928b356acb62c2831b379bdf3b73803b184cf16b219e3882a050516608ed2"
    sha256 cellar: :any,                 sonoma:         "d3c785ad48b40f5926c8cc5559dc64d1c08853da290b4623f42fb08b0067f880"
    sha256 cellar: :any,                 ventura:        "404ad76d5d69c18103c3643b3297e122e2b7d86f4d2fd33e455701efc943efa6"
    sha256 cellar: :any,                 monterey:       "b86432bb9d57ceae6cee8beacb68b2ea07d06e0461d643844644d4ecaccd99c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3e499685020250aa4dcd1fe552189f86e735a7684743e20ce9214a6fa8c5660"
  end

  head do
    url "https:github.comrust-langrust.git", branch: "master"

    resource "cargo" do
      url "https:github.comrust-langcargo.git", branch: "master"
    end
  end

  depends_on "libgit2@1.7"
  depends_on "libssh2"
  depends_on "llvm"
  depends_on macos: :sierra
  depends_on "openssl@3"
  depends_on "pkg-config"

  uses_from_macos "python" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

  link_overwrite "etcbash_completion.dcargo"

  # From https:github.comrust-langrustblob#{version}srcstage0
  resource "cargobootstrap" do
    on_macos do
      on_arm do
        url "https:static.rust-lang.orgdist2024-06-13cargo-1.79.0-aarch64-apple-darwin.tar.xz"
        sha256 "2cc674f17c18b0c01e0e5a8e5caedc26b0f499d2cc10605cf1a838e2cad9ef7d"
      end
      on_intel do
        url "https:static.rust-lang.orgdist2024-06-13cargo-1.79.0-x86_64-apple-darwin.tar.xz"
        sha256 "e1326c13b7437a72e061a2d662400c114ef87b73c45ef8823ea1b2bdc3140109"
      end
    end

    on_linux do
      on_arm do
        url "https:static.rust-lang.orgdist2024-06-13cargo-1.79.0-aarch64-unknown-linux-gnu.tar.xz"
        sha256 "4ca5e9bd141b0111387ea1aa0355f87eb8d0da52fbc616cefa4ecde4997aa65b"
      end
      on_intel do
        url "https:static.rust-lang.orgdist2024-06-13cargo-1.79.0-x86_64-unknown-linux-gnu.tar.xz"
        sha256 "07fcadd27b645ad58ff4dae5ef166fd730311bbae8f25f6640fe1bfd2a1f3c3c"
      end
    end
  end

  def install
    # relates to https:github.comrust-langrustpull126507
    odie "bump to use libgit2 1.8" if version >= "1.81.0"

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
        Formula["libgit2@1.7"].opt_libshared_library("libgit2"),
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