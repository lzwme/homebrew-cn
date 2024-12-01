class SignalCli < Formula
  desc "CLI and dbus interface for WhisperSystemslibsignal-service-java"
  homepage "https:github.comAsamKsignal-cli"
  url "https:github.comAsamKsignal-cliarchiverefstagsv0.13.10.tar.gz"
  sha256 "b1947eb37064e7a196c5b1012cb9fd111126c1f9449bbd43f5f0e3971a2dc173"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "acaaf3f22193ba506508e24b5ba5f6cd6bf889487456679803e1c27b9e8fed1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "600fbcfd84dac5bf9e8713d8160928402dd724211bdaa5ff21e1b9f83a2422dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c53f355a23a23ea1da94b56831da5a9c676ad5eaca6e36e97d6f60d06b1a6b6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "f7c73ca10d7ab2f6ffe635c13830bdf2a75770466bacdca279a58f27aec40cce"
    sha256 cellar: :any_skip_relocation, ventura:       "81ba923ea64ca023c47fc614d5efc651f03dd5b5cfaeae274e91ae1f5cc303e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a2c51f04b131c96cce8369cc57ac9b11354fbbd40a0fe38355505d46b91557a"
  end

  depends_on "cmake" => :build # For `boring-sys` crate in `libsignal-client`
  depends_on "gradle" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  depends_on "openjdk@21"

  uses_from_macos "llvm" => :build # For `libclang`, used by `boring-sys` crate
  uses_from_macos "zip" => :build

  # https:github.comAsamKsignal-cliwikiProvide-native-lib-for-libsignal#determine-the-required-libsignal-client-version
  # To check the version of `libsignal-client`, run:
  # url=https:github.comAsamKsignal-clireleasesdownloadv$versionsignal-cli-$version.tar.gz
  # curl -fsSL $url | tar -tz | grep libsignal-client
  resource "libsignal-client" do
    url "https:github.comsignalapplibsignalarchiverefstagsv0.62.0.tar.gz"
    sha256 "1f04eac98fcd6b34ab61ce6fc65f6c46eceab0f1b407a65d95207a8a5050594c"
  end

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("21")
    system "gradle", "build"
    system "gradle", "installDist"
    libexec.install (buildpath"buildinstallsignal-cli").children
    (libexec"binsignal-cli.bat").unlink
    (bin"signal-cli").write_env_script libexec"binsignal-cli", Language::Java.overridable_java_home_env("21")

    resource("libsignal-client").stage do |r|
      # https:github.comAsamKsignal-cliwikiProvide-native-lib-for-libsignal#manual-build

      libsignal_client_jar = libexec.glob("liblibsignal-client-*.jar").first
      embedded_jar_version = Version.new(libsignal_client_jar.to_s[libsignal-client-(.*)\.jar$, 1])
      res = r.resource
      odie "#{res.name} needs to be updated to #{embedded_jar_version}!" if embedded_jar_version != res.version

      # rm originally-embedded libsignal_jni lib
      system "zip", "-d", libsignal_client_jar, "libsignal_jni_*.so", "libsignal_jni_*.dylib", "signal_jni_*.dll"

      # build & embed library for current platform
      cd "java" do
        inreplace "settings.gradle", "include ':android'", ""
        system ".build_jni.sh", "desktop"
        cd "clientsrcmainresources" do
          arch = Hardware::CPU.intel? ? "amd64" : "aarch64"
          system "zip", "-u", libsignal_client_jar, shared_library("libsignal_jni_#{arch}")
        end
      end
    end
  end

  test do
    # test 1: checks class loading is working and version is correct
    output = shell_output("#{bin}signal-cli --version")
    assert_match "signal-cli #{version}", output

    # test 2: ensure crypto is working
    begin
      io = IO.popen("#{bin}signal-cli link", err: [:child, :out])
      sleep 24
    ensure
      Process.kill("SIGINT", io.pid)
      Process.wait(io.pid)
    end
    assert_match "sgnl:linkdevice?uuid=", io.read
  end
end