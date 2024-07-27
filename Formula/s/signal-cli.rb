class SignalCli < Formula
  desc "CLI and dbus interface for WhisperSystemslibsignal-service-java"
  homepage "https:github.comAsamKsignal-cli"
  url "https:github.comAsamKsignal-cliarchiverefstagsv0.13.5.tar.gz"
  sha256 "c1fdc8ccff324278a9357aed04fa7de88ecba1fc270f5555b5cea77d415d1342"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5df7b4a1b402f0bad8a39e3bbcf3c6bbe2d065f846827919ed580db76b7179e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd97c3784b9732002ac2459f02bc98ce271176c5fe69fbf38b3e7d46d400bd4f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71d800c2749004ca1ed6214b87b6acbb4a5f8e6cf775a0aede637a82b6e83ffa"
    sha256 cellar: :any_skip_relocation, sonoma:         "42724c8265d152666e72151c1ffa3d753c597ac05b93481fc33fadf822cd7bb2"
    sha256 cellar: :any_skip_relocation, ventura:        "7392fcf9650f2efa1c80113272339dbeb82f8a369f232d345f97a18326036d42"
    sha256 cellar: :any_skip_relocation, monterey:       "58b01a46c5702ebdea14296964595b0a7c0f43656bce265ec3a7c7ca9449870a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d98bafe277e4c3dc429fd4907b809e598445cb1fbfb08088e4f705f1e0cdc7a5"
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
    url "https:github.comsignalapplibsignalarchiverefstagsv0.52.2.tar.gz"
    sha256 "40ddc51bc5bf1013c583c07717ed00cedfafda55f9f9a43aad72f9a55986b199"
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