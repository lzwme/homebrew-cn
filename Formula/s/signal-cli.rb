class SignalCli < Formula
  desc "CLI and dbus interface for WhisperSystemslibsignal-service-java"
  homepage "https:github.comAsamKsignal-cli"
  url "https:github.comAsamKsignal-cliarchiverefstagsv0.13.17.tar.gz"
  sha256 "40bb1259ff2e84f97d3b5f3b1d96d30bd71e614ca19b5d5572f4a67e9b944eea"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, sonoma:       "e30310f20902a466190b7f1cce4bdf3e9f06f5477192c3374ba27b3a84bbcd38"
    sha256 cellar: :any_skip_relocation, ventura:      "cbbd8b4a39256101e9bfb047fd185fbde23898a7bee7ad9b0c04b3df3e789eca"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "fc3a219efaeaac56c04badf3f9b1d2c48e99eb4ba54d820f918152ceacfb2437"
  end

  depends_on "cmake" => :build # For `boring-sys` crate in `libsignal-client`
  depends_on "gradle" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  depends_on "openjdk@21"

  uses_from_macos "llvm" => :build # For `libclang`, used by `boring-sys` crate
  uses_from_macos "zip" => :build

  on_linux do
    depends_on arch: :x86_64 # `:libsignal-cli:test` failure, https:github.comAsamKsignal-cliissues1787
  end

  # https:github.comAsamKsignal-cliwikiProvide-native-lib-for-libsignal#determine-the-required-libsignal-client-version
  # To check the version of `libsignal-client`, run:
  # url=https:github.comAsamKsignal-clireleasesdownloadv$versionsignal-cli-$version.tar.gz
  # curl -fsSL $url | tar -tz | grep libsignal-client
  resource "libsignal-client" do
    url "https:github.comsignalapplibsignalarchiverefstagsv0.76.0.tar.gz"
    sha256 "64a78ff474e102eedeeba25838fc6f3375e6e5dcdd999be6596250bd1419268a"
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