class SignalCli < Formula
  desc "CLI and dbus interface for WhisperSystemslibsignal-service-java"
  homepage "https:github.comAsamKsignal-cli"
  url "https:github.comAsamKsignal-cliarchiverefstagsv0.13.11.tar.gz"
  sha256 "7cf1e37f04a6f71397829228e7de76f4d82ebe779e3cb1f8b337375d6f090426"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9521f01faf368dcc2999cbde7956d180065fb25177b690ee5800c3ed24dc53c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dec8e89bcf62223a2ecc80a8c0864db4a8c07dc8c650d0834a50d6ee8cd92243"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ee8086d908bb7414293e518be48901986a2514c2702da801416331945377e751"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f781ac90c6efb28af7a67e8fdbe3939545528b6ee8bf520208b612f839d62f2"
    sha256 cellar: :any_skip_relocation, ventura:       "0df967c68973eadf3e3873039b2762cc2b2318304e721c813d4cb3cc023422a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "971d37db8abc3e727fe22cc918b46a4439f4c09ea3bcb16a0cf40a640f2a2bb7"
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
    url "https:github.comsignalapplibsignalarchiverefstagsv0.64.0.tar.gz"
    sha256 "2c5d2bb3e546ec618d42331f5f1892cfffd9f9087dcdef0d0b988469266cfa1e"
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