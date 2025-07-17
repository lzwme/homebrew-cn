class SignalCli < Formula
  desc "CLI and dbus interface for WhisperSystems/libsignal-service-java"
  homepage "https://github.com/AsamK/signal-cli"
  url "https://ghfast.top/https://github.com/AsamK/signal-cli/archive/refs/tags/v0.13.18.tar.gz"
  sha256 "5040545c43069958bbf914331e39492ae7dde3497dbc2c89e0e4f3ff75fb83ea"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4db78cba14472255c27052af30978e033bcac1c0bd95eebe36672b38fce5b43b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "661bd3d4173079a2058d24387a93f99630963bc936cba948c798c485034b5def"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "319bacce3b191b377b306b3de7b9b4f9f3cd85d28ecb6759ffe1c731c1cb24e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b859f7773e62a548069b6bab41370a5785eeac0a00b026a7cf94d0f4e4fc04c"
    sha256 cellar: :any_skip_relocation, ventura:       "c7d196e733ed2dc069a0e2b544d180a30ee3d6229d62171b2c2b7198998ad7e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f516675663977674d1a8b298221de16725637b981958b6e41a7614ddf6f80f99"
  end

  depends_on "cmake" => :build # For `boring-sys` crate in `libsignal-client`
  depends_on "gradle" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  depends_on "openjdk@21"

  uses_from_macos "llvm" => :build # For `libclang`, used by `boring-sys` crate
  uses_from_macos "zip" => :build

  on_linux do
    depends_on arch: :x86_64 # `:libsignal-cli:test` failure, https://github.com/AsamK/signal-cli/issues/1787
  end

  # https://github.com/AsamK/signal-cli/wiki/Provide-native-lib-for-libsignal#determine-the-required-libsignal-client-version
  # To check the version of `libsignal-client`, run:
  # url=https://ghfast.top/https://github.com/AsamK/signal-cli/releases/download/v$version/signal-cli-$version.tar.gz
  # curl -fsSL $url | tar -tz | grep libsignal-client
  resource "libsignal-client" do
    url "https://ghfast.top/https://github.com/signalapp/libsignal/archive/refs/tags/v0.76.3.tar.gz"
    sha256 "7e474269dfa98929088aaa367e963cd6cab71b60d84cef4da28f97573c24984f"
  end

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("21")
    system "gradle", "build"
    system "gradle", "installDist"
    libexec.install (buildpath/"build/install/signal-cli").children
    (libexec/"bin/signal-cli.bat").unlink
    (bin/"signal-cli").write_env_script libexec/"bin/signal-cli", Language::Java.overridable_java_home_env("21")

    resource("libsignal-client").stage do |r|
      # https://github.com/AsamK/signal-cli/wiki/Provide-native-lib-for-libsignal#manual-build

      libsignal_client_jar = libexec.glob("lib/libsignal-client-*.jar").first
      embedded_jar_version = Version.new(libsignal_client_jar.to_s[/libsignal-client-(.*)\.jar$/, 1])
      res = r.resource
      odie "#{res.name} needs to be updated to #{embedded_jar_version}!" if embedded_jar_version != res.version

      system "zip", "-d", libsignal_client_jar, "libsignal_jni_*.so", "libsignal_jni_*.dylib", "signal_jni_*.dll"

      cd "java" do
        inreplace "settings.gradle", "include ':android'", ""
        system "./build_jni.sh", "desktop"
        cd "client/src/main/resources" do
          arch = Hardware::CPU.intel? ? "amd64" : "aarch64"
          system "zip", "-u", libsignal_client_jar, shared_library("libsignal_jni_#{arch}")
        end
      end
    end
  end

  test do
    output = shell_output("#{bin}/signal-cli --version")
    assert_match "signal-cli #{version}", output

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