class SignalCli < Formula
  desc "CLI and dbus interface for WhisperSystems/libsignal-service-java"
  homepage "https://github.com/AsamK/signal-cli"
  url "https://ghproxy.com/https://github.com/AsamK/signal-cli/archive/refs/tags/v0.11.10.tar.gz"
  sha256 "668193a8332981da838cb556876172e3298b44ac38ce6bfa412ddb17fc13cc99"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed5febc18cfcf7862e6fe055d7882ca591164f25530f7dd27de15cc0e4e5aa64"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88eb3325ebe1351c66a04a1d712116c3e2c9cd3835395d46b8e76627ddd158bb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fab1602c4906d94988de296b809b0e7ae65f92038f38ef1e6a3f59af89bd449f"
    sha256 cellar: :any_skip_relocation, ventura:        "30b98e5acf78e2555915087ecad212853c4807faf38dd5f5fb216e7afae921a4"
    sha256 cellar: :any_skip_relocation, monterey:       "5407c3f2e47f9f5d1547ed1898eebce1dab17dd2b1dea87882810d676040e269"
    sha256 cellar: :any_skip_relocation, big_sur:        "62f60e81d6909b369225dea6d4bf9c683c16fdf546747db67a3cd89e106945f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69295620ac8ad78e15f785601bb948fca55df29f2964d62ea44271815e960b05"
  end

  depends_on "cmake" => :build # For `boring-sys` crate in `libsignal-client`
  depends_on "gradle" => :build
  depends_on "protobuf" => :build
  # the libsignal-client build targets a specific rustc listed in the file
  # https://github.com/signalapp/libsignal/blob/#{libsignal-client.version}/rust-toolchain
  # which doesn't automatically happen if we use brew-installed rust. rustup-init
  # allows us to use a toolchain that lives in HOMEBREW_CACHE
  depends_on "rustup-init" => :build

  depends_on "openjdk"

  uses_from_macos "zip" => :build

  # Use `llvm@15` to work around build failure with Clang 16 described in
  # rust-lang/rust-bindgen#2312.
  # TODO: Switch back to `uses_from_macos "llvm" => :build` when `libsignal`
  # crate's dependency `boring-sys` uses `bindgen` v0.62.0 or newer.
  on_linux do
    depends_on "llvm@15" => :build # For `libclang`, used by `boring-sys` crate
  end

  # per https://github.com/AsamK/signal-cli/wiki/Provide-native-lib-for-libsignal#libsignal-client
  # we want the specific libsignal-client version from 'signal-cli-#{version}/lib/libsignal-client-X.X.X.jar'
  resource "libsignal-client" do
    url "https://ghproxy.com/https://github.com/signalapp/libsignal/archive/refs/tags/v0.23.1.tar.gz"
    sha256 "36eff4a90b13bbc769c4af118dbe9686aa1e38dcf9ad4b09dca8e8274bc6c8ee"
  end

  def install
    system "gradle", "build"
    system "gradle", "installDist"
    libexec.install (buildpath/"build/install/signal-cli").children
    (libexec/"bin/signal-cli.bat").unlink
    (bin/"signal-cli").write_env_script libexec/"bin/signal-cli", Language::Java.overridable_java_home_env

    # this will install the necessary cargo/rustup toolchain bits in HOMEBREW_CACHE
    system Formula["rustup-init"].bin/"rustup-init", "-qy", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"

    resource("libsignal-client").stage do |r|
      # https://github.com/AsamK/signal-cli/wiki/Provide-native-lib-for-libsignal#building-libsignal-client-yourself

      libsignal_client_jar = libexec.glob("lib/libsignal-client-*.jar").first
      embedded_jar_version = Version.new(libsignal_client_jar.to_s[/libsignal-client-(.*)\.jar$/, 1])
      odie "#{r.name} needs to be updated to #{embedded_jar_version}!" if embedded_jar_version != r.version

      # rm originally-embedded libsignal_jni lib
      system "zip", "-d", libsignal_client_jar, "libsignal_jni.so", "libsignal_jni.dylib", "signal_jni.dll"

      # build & embed library for current platform
      cd "java" do
        inreplace "settings.gradle", "include ':android'", ""
        system "./build_jni.sh", "desktop"
        cd "shared/resources" do
          system "zip", "-u", libsignal_client_jar, shared_library("libsignal_jni")
        end
      end
    end
  end

  test do
    # test 1: checks class loading is working and version is correct
    output = shell_output("#{bin}/signal-cli --version")
    assert_match "signal-cli #{version}", output

    # test 2: ensure crypto is working
    begin
      io = IO.popen("#{bin}/signal-cli link", err: [:child, :out])
      sleep 24
    ensure
      Process.kill("SIGINT", io.pid)
      Process.wait(io.pid)
    end
    assert_match "sgnl://linkdevice?uuid=", io.read
  end
end