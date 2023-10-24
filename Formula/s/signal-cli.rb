class SignalCli < Formula
  desc "CLI and dbus interface for WhisperSystems/libsignal-service-java"
  homepage "https://github.com/AsamK/signal-cli"
  url "https://ghproxy.com/https://github.com/AsamK/signal-cli/archive/refs/tags/v0.12.4.tar.gz"
  sha256 "d9aab61f1c0e08e55e0d72a3aeb8b8479aeb02c21d0490b9b2bf1f5167d1b402"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d77a6f5fcb24943a8008b514d608f7c42d6d750522c07ce2c8e5bae8cc470546"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0583af1b4ed13feaf63389a668e18f1925c1ad3271928cf7ad62bd2ed1eaa4e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22e543a9d6430b49c43c8aadfb3aaca182e9d25aba1f939d4bb40b4042329b3d"
    sha256 cellar: :any_skip_relocation, sonoma:         "2250862bdee9bc3c2fc7841f424a182b64574bd2664e5f6d72e8647f2cdde8f9"
    sha256 cellar: :any_skip_relocation, ventura:        "45deed292ad1a70dad9ab624c39ab148ebf1c2a9ce42e14bda7fdfe1c4b3e710"
    sha256 cellar: :any_skip_relocation, monterey:       "94a2c4a5ece9ddd9d48f36f188fa1baee07870efdffdf15b5756b62bc0410f17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16c56075d294e73cdb51e75a8b622e1edef90dbd0998210ebc279df82496b8cf"
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

  uses_from_macos "llvm" => :build # For `libclang`, used by `boring-sys` crate
  uses_from_macos "zip" => :build

  # https://github.com/AsamK/signal-cli/wiki/Provide-native-lib-for-libsignal#determine-the-required-libsignal-client-version
  # To check the version of `libsignal-client`, run:
  # url=https://ghproxy.com/https://github.com/AsamK/signal-cli/releases/download/v$version/signal-cli-$version.tar.gz
  # curl -fsSL $url | tar -tz | grep libsignal-client
  resource "libsignal-client" do
    url "https://ghproxy.com/https://github.com/signalapp/libsignal/archive/refs/tags/v0.32.1.tar.gz"
    sha256 "4751e197d798555c6e8c9a869c41692ed3c72a4d34738c28c6f6a1761044e777"
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
      # https://github.com/AsamK/signal-cli/wiki/Provide-native-lib-for-libsignal#manual-build

      libsignal_client_jar = libexec.glob("lib/libsignal-client-*.jar").first
      embedded_jar_version = Version.new(libsignal_client_jar.to_s[/libsignal-client-(.*)\.jar$/, 1])
      res = r.resource
      odie "#{res.name} needs to be updated to #{embedded_jar_version}!" if embedded_jar_version != res.version

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