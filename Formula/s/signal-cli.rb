class SignalCli < Formula
  desc "CLI and dbus interface for WhisperSystems/libsignal-service-java"
  homepage "https://github.com/AsamK/signal-cli"
  url "https://ghproxy.com/https://github.com/AsamK/signal-cli/archive/refs/tags/v0.12.2.tar.gz"
  sha256 "d6b115553c0b061691069ebf71093d185d86939148c699f31f6c3fc8882dcca7"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8045d9d482db399f2cc8d12761f63e27c351a725a2036d3fa827cbd858fa0228"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3d7b3c047b88e0dee6b68c32335ba1b0bce34a9bd7f486da5d920dd0d82098b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22e8bc62b967ff760d28da2145a23c4d6ad6de79ac5bfbf27ed8bf87f04cc3c4"
    sha256 cellar: :any_skip_relocation, sonoma:         "a1af8f910d07002e2a1efa549999e0f77c67baf95cf407c5b86ad45acfd36f8f"
    sha256 cellar: :any_skip_relocation, ventura:        "f424abaa2a42cf80e6081e3e812675c27ff4d80efd0be558cf0972fb04ccf76b"
    sha256 cellar: :any_skip_relocation, monterey:       "87957f5c9a9a6ac2a6efb9e45fd2319c0d5ec2f7c417b6e4e5de6210cb7d9dea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e953816120b6bb49e8562a9bde4d50f2907ae3621b27306078e8f01f857f56b"
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
  # curl -fsSL https://ghproxy.com/https://github.com/AsamK/signal-cli/releases/download/v${version}/signal-cli-${version}-Linux.tar.gz |
  #   tar -tz |
  #   grep libsignal-client
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