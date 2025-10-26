class SignalCli < Formula
  desc "CLI and dbus interface for WhisperSystems/libsignal-service-java"
  homepage "https://github.com/AsamK/signal-cli"
  url "https://ghfast.top/https://github.com/AsamK/signal-cli/archive/refs/tags/v0.13.21.tar.gz"
  sha256 "3b751f8989a48a0d39c87d349d311541ba3ec286f7fb8de752596c4d07788728"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb591048816fdfd36313952cfb10a9a02f40765fd87261faf75fbd68d7b3c070"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57ffb2cba1df9792aa26133a3c7e2180f6b7ebd3f9076a405d7155c140480e7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3eba953dea665181ed5576e95f58e2f9d81fd878f2610131f742020ccc849f83"
    sha256 cellar: :any_skip_relocation, sonoma:        "1cd331161e9d7ffe6f3c83a10261c075c28398ad75923eb7b8a76449626898ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4981149ba16679746d5ad9e28af664c9bd8994c1fdd92f630d3aeff2ec7c8f84"
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
    url "https://ghfast.top/https://github.com/signalapp/libsignal/archive/refs/tags/v0.84.0.tar.gz"
    sha256 "eb68997586ce8a0f3bfcb57a35b3bab9e45364e371dd37d0d55ab28f3a9671a2"
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