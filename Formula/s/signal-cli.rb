class SignalCli < Formula
  desc "CLI and dbus interface for WhisperSystemslibsignal-service-java"
  homepage "https:github.comAsamKsignal-cli"
  url "https:github.comAsamKsignal-cliarchiverefstagsv0.13.4.tar.gz"
  sha256 "a09d355fa5ece4dd6d9d4847c0c1c255159f29304007d02a3aa733c7b02144a3"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1136c4c0b661dcdaa854f144528ce25c8b8c67c7effbd2ee603623931d72c343"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "57090d32f75e684983730345b20a7dbbd0a35cee682627be146db615b7fc4c1f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d0e6f60d8d8acb8d0b82e1939e9505c0be04af190e691b106b1e1172d26f8a7"
    sha256 cellar: :any_skip_relocation, sonoma:         "932339d14a6d67a975fb13d525d0cc3f6db3dbdfc70caa4ff999e5143baa1295"
    sha256 cellar: :any_skip_relocation, ventura:        "b1d8b76438b90073a56109013e62b8d80fc806a213dea9767e52b0e15041b4ea"
    sha256 cellar: :any_skip_relocation, monterey:       "bf794f5735b1733e4476b78fed1f7ba1e42bc1f47fd50930bc7af41044d83352"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "195e1dd36212945d8f8fff806eb5e88566ba3e784cda684edcaf45243aa29636"
  end

  depends_on "cmake" => :build # For `boring-sys` crate in `libsignal-client`
  depends_on "gradle" => :build
  depends_on "protobuf" => :build
  # libsignal-client requires a specific version of rustc
  # https:github.comsignalapplibsignalblob#{libsignal-client.version}rust-toolchain
  depends_on "rustup" => :build

  depends_on "openjdk@21"

  uses_from_macos "llvm" => :build # For `libclang`, used by `boring-sys` crate
  uses_from_macos "zip" => :build

  # https:github.comAsamKsignal-cliwikiProvide-native-lib-for-libsignal#determine-the-required-libsignal-client-version
  # To check the version of `libsignal-client`, run:
  # url=https:github.comAsamKsignal-clireleasesdownloadv$versionsignal-cli-$version.tar.gz
  # curl -fsSL $url | tar -tz | grep libsignal-client
  resource "libsignal-client" do
    url "https:github.comsignalapplibsignalarchiverefstagsv0.47.0.tar.gz"
    sha256 "825d61738f9b6cf37ef84a11bc313a59d1468dc2bc164860f4f5aa3b6a7623e2"
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
      system "zip", "-d", libsignal_client_jar, "libsignal_jni.so", "libsignal_jni.dylib", "signal_jni.dll"

      # build & embed library for current platform
      cd "java" do
        inreplace "settings.gradle", "include ':android'", ""
        system ".build_jni.sh", "desktop"
        cd "sharedresources" do
          system "zip", "-u", libsignal_client_jar, shared_library("libsignal_jni")
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