class SignalCli < Formula
  desc "CLI and dbus interface for WhisperSystemslibsignal-service-java"
  homepage "https:github.comAsamKsignal-cli"
  url "https:github.comAsamKsignal-cliarchiverefstagsv0.13.1.tar.gz"
  sha256 "0b819812b76a45d342ff4cd657666861f0b47b2a4b33ff33fd9572338de608c4"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "975926a95120d2e952aad2e62808616e50d725f1dfbc3e063cbe096a358b3491"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b75f254b9b345acefd106aa342501cdd613e024f2677345808c5cc5564763f47"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03e354ccbdff29069c5696ef46d49ec42ede6ef2b9c203c5d717f2db8f4cba70"
    sha256 cellar: :any_skip_relocation, sonoma:         "30808885091a4d29f48ef1bd2957355c0c83d77dffd0d27b184121cf7178917b"
    sha256 cellar: :any_skip_relocation, ventura:        "f64bdd2ae2ccca143944d8c0b913475a9e9ab885b925abca73e3f83b1655f628"
    sha256 cellar: :any_skip_relocation, monterey:       "342be1e7ff766fa28d5223b98fdc872c1dbe8e78ea5e3c256c5f5349b90a8c97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf13c22ba780d08c408229493ae7c0aee5d99105adce1610db52b3759bed6a89"
  end

  depends_on "cmake" => :build # For `boring-sys` crate in `libsignal-client`
  depends_on "gradle" => :build
  depends_on "protobuf" => :build
  # the libsignal-client build targets a specific rustc listed in the file
  # https:github.comsignalapplibsignalblob#{libsignal-client.version}rust-toolchain
  # which doesn't automatically happen if we use brew-installed rust. rustup-init
  # allows us to use a toolchain that lives in HOMEBREW_CACHE
  depends_on "rustup-init" => :build

  depends_on "openjdk"

  uses_from_macos "llvm" => :build # For `libclang`, used by `boring-sys` crate
  uses_from_macos "zip" => :build

  # https:github.comAsamKsignal-cliwikiProvide-native-lib-for-libsignal#determine-the-required-libsignal-client-version
  # To check the version of `libsignal-client`, run:
  # url=https:github.comAsamKsignal-clireleasesdownloadv$versionsignal-cli-$version.tar.gz
  # curl -fsSL $url | tar -tz | grep libsignal-client
  resource "libsignal-client" do
    url "https:github.comsignalapplibsignalarchiverefstagsv0.39.2.tar.gz"
    sha256 "0a20347fdc44ea81474acd0dfd4086d8e30a0b2098914c86e73eec90ce2f9994"
  end

  def install
    system "gradle", "build"
    system "gradle", "installDist"
    libexec.install (buildpath"buildinstallsignal-cli").children
    (libexec"binsignal-cli.bat").unlink
    (bin"signal-cli").write_env_script libexec"binsignal-cli", Language::Java.overridable_java_home_env

    # this will install the necessary cargorustup toolchain bits in HOMEBREW_CACHE
    system Formula["rustup-init"].bin"rustup-init", "-qy", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE"cargo_cachebin"

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