class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https:www.rust-lang.org"
  license any_of: ["Apache-2.0", "MIT"]

  stable do
    url "https:static.rust-lang.orgdistrustc-1.77.2-src.tar.gz"
    sha256 "c61457ef8f596638fddbc7716778b2f6b99ff12513a3b0f13994c3bc521638c3"

    # From https:github.comrust-langrusttree#{version}srctools
    resource "cargo" do
      url "https:github.comrust-langcargoarchiverefstags0.78.1.tar.gz"
      sha256 "0283fecebb6d3cbd111688eb0359edaf6676f4b2829201a8afe5a0e3afdb4b48"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3720b820093a5e4c7f71510c02ad62a1e93eacd7352c885b5d70c8621d761646"
    sha256 cellar: :any,                 arm64_ventura:  "7a5cb09a5860dd09d6a5aa2a447c6c37b9737b8619513a60b080ecc06d423275"
    sha256 cellar: :any,                 arm64_monterey: "4be8de99bdb192877d563de4ac2d2e19ccf92adb24b9d82dc00b928477f66a91"
    sha256 cellar: :any,                 sonoma:         "c3d3c807a488695de5d7a0922f3eaaadd46ef448debeaebce6e72133cf281917"
    sha256 cellar: :any,                 ventura:        "bcaaded3ee2eb1cdc536e283f48284c31f2f91a6c2ed8165d0bf9f425b7134aa"
    sha256 cellar: :any,                 monterey:       "b2b4f358f42e57ee2c0d56ac0b3f7b6cb9776f8486b5b993fced2e77724d0e95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7805c4daa1cf4b4495f4c68637e8286fd78e653dd4a60d70c8e4a2b55c138a8"
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