class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https:www.rust-lang.org"
  license any_of: ["Apache-2.0", "MIT"]

  stable do
    url "https:static.rust-lang.orgdistrustc-1.77.1-src.tar.gz"
    sha256 "ee106e4c569f52dba3b5b282b105820f86bd8f6b3d09c06b8dce82fb1bb3a4a1"

    # From https:github.comrust-langrusttree#{version}srctools
    resource "cargo" do
      url "https:github.comrust-langcargoarchiverefstags0.78.1.tar.gz"
      sha256 "0283fecebb6d3cbd111688eb0359edaf6676f4b2829201a8afe5a0e3afdb4b48"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "57e05fe8950a84f5c22016467b7db6c7e1b32d2353e0a2caf2705b947b4bffed"
    sha256 cellar: :any,                 arm64_ventura:  "a0f0e79a195bf0af8e0ab492b3adc42f5508a3bb4b2f02da6c46721bd7b8ede0"
    sha256 cellar: :any,                 arm64_monterey: "12d0364f7896b6bbca3a1b4ea77a499c2db3d270c8b0b43a5a4279bbbff690e4"
    sha256 cellar: :any,                 sonoma:         "f63cf6e01eed11cb997fec63e6ab89e88c3218f9859d8b42a47fabb3aef6a79a"
    sha256 cellar: :any,                 ventura:        "55f929ec93f7a44e88fb3e024bf898dd66b3255b138f9bae927a78058c2d681b"
    sha256 cellar: :any,                 monterey:       "ea0402ccb8ca05e65d43ff010f4de6d991e9418e435e5a8483a9f3c72d6895dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43e6988a3bc5d4d337f65765272b08f1547201ad6b84b3ca153573f916c3e5b8"
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
        url "https:static.rust-lang.orgdist2024-02-08cargo-1.76.0-aarch64-apple-darwin.tar.xz"
        sha256 "c963d3bf8f07077b0c87922e53ebb8999c601848def13d6f60a7a102dfa2a8a5"
      end
      on_intel do
        url "https:static.rust-lang.orgdist2024-02-08cargo-1.76.0-x86_64-apple-darwin.tar.xz"
        sha256 "c69b9e1167d8c67e46b6c933417af09fd8e26e2ee14c04aadad097977b3cd6a3"
      end
    end

    on_linux do
      on_arm do
        url "https:static.rust-lang.orgdist2024-02-08cargo-1.76.0-aarch64-unknown-linux-gnu.tar.xz"
        sha256 "d0c54d824e64b7313a974409541ca3a157b3ed7299865786bd0c440b0e073091"
      end
      on_intel do
        url "https:static.rust-lang.orgdist2024-02-08cargo-1.76.0-x86_64-unknown-linux-gnu.tar.xz"
        sha256 "30ec0ad9fca443ec12c544f9ce448dacdde411a45b9042961938b650e918ccfb"
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