class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https:www.rust-lang.org"
  license any_of: ["Apache-2.0", "MIT"]

  stable do
    url "https:static.rust-lang.orgdistrustc-1.75.0-src.tar.gz"
    sha256 "5b739f45bc9d341e2d1c570d65d2375591e22c2d23ef5b8a37711a0386abc088"

    # From https:github.comrust-langrusttree#{version}srctools
    resource "cargo" do
      url "https:github.comrust-langcargoarchiverefstags0.76.0.tar.gz"
      sha256 "52d57889715cdfe0070b13f6d4dbfc4affdafc763483269e78b6ebd7166fdb83"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ce132f912aa8a03b9e8952acb02aa0156f04e96689bcaa46a664d1f9b9353331"
    sha256 cellar: :any,                 arm64_ventura:  "bbc43997dba15c4e3fe6d5cf2baf4ac1f6168868337dbd38e8965126b643f6c3"
    sha256 cellar: :any,                 arm64_monterey: "87c0e31b5f7bba2316ba14fe3956f7adda20a897acb5fb4098dd3e051fec8e28"
    sha256 cellar: :any,                 sonoma:         "bf368b8ce113863533f5c2ac59e7650ca15912929118647862d6e0f8bdcd19d1"
    sha256 cellar: :any,                 ventura:        "f8f5fdc38479518838a72d0ea0784815c6213b53467b18c1a21b193e7739780e"
    sha256 cellar: :any,                 monterey:       "886f7fe8d360316b79c4e0b403f1f8fed4e8933a8a2af459602bb700bf994e76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f6e7e26fd0d84789db75782ac49697a9d00dcd2a3940f0a6c3fce4e2d21a2ac"
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

  uses_from_macos "python" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

  # From https:github.comrust-langrustblob#{version}srcstage0.json
  resource "cargobootstrap" do
    on_macos do
      on_arm do
        url "https:static.rust-lang.orgdist2023-11-16cargo-1.74.0-aarch64-apple-darwin.tar.xz"
        sha256 "5c14e9b3a458d728d89e02f4e024b710d5b0eb8c45249066fe666d2094fbf233"
      end
      on_intel do
        url "https:static.rust-lang.orgdist2023-11-16cargo-1.74.0-x86_64-apple-darwin.tar.xz"
        sha256 "5c1c4f5985a48ad02bcff881c5a9c983218bc1eefc083403579147a3292ba073"
      end
    end

    on_linux do
      on_arm do
        url "https:static.rust-lang.orgdist2023-11-16cargo-1.74.0-aarch64-unknown-linux-gnu.tar.xz"
        sha256 "a18dc9132cf76ccba90bcbb53b56a4d37ebfb34845f61e79f7b5d4710a269647"
      end
      on_intel do
        url "https:static.rust-lang.orgdist2023-11-16cargo-1.74.0-x86_64-unknown-linux-gnu.tar.xz"
        sha256 "f219386d4569c40b660518e99267afff428c13bf980bda7a614c8d4038d013f6"
      end
    end
  end

  # Fixes 'could not read dir "...codegen-backends"' on 12-arm64.
  # See https:github.comHomebrewhomebrew-corepull154526#issuecomment-1814795860
  patch :DATA

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
    cargo_src_path.rmtree
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
      --enable-vendor
      --disable-cargo-native-static
      --enable-profiler
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

    (lib"rustlibsrcrust").install "library"
    rm_f [
      bin.glob("*.old"),
      lib"rustlibinstall.log",
      lib"rustlibuninstall.sh",
      (lib"rustlib").glob("manifest-*"),
    ]
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

__END__
diff --git asrcbootstrapsrccorebuild_stepscompile.rs bsrcbootstrapsrccorebuild_stepscompile.rs
index 7021a95..af69860 100644
--- asrcbootstrapsrccorebuild_stepscompile.rs
+++ bsrcbootstrapsrccorebuild_stepscompile.rs
@@ -592,7 +592,9 @@ impl Step for StdLink {
                 .join("stage0librustlib")
                 .join(&host)
                 .join("codegen-backends");
-            builder.cp_r(&stage0_codegen_backends, &sysroot_codegen_backends);
+            if stage0_codegen_backends.exists() {
+                builder.cp_r(&stage0_codegen_backends, &sysroot_codegen_backends);
+            }
         }
     }
 }