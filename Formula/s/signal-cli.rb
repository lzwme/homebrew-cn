class SignalCli < Formula
  desc "CLI and dbus interface for WhisperSystemslibsignal-service-java"
  homepage "https:github.comAsamKsignal-cli"
  url "https:github.comAsamKsignal-cliarchiverefstagsv0.13.9.tar.gz"
  sha256 "a8033b84bdcf1246a3249b0d46b33331c4e52f73f09452870673f9a871d56444"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19b0e8a79c3f629d693650fc2b2e8eff93c4f343feb8633d77382bd21c74d687"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1372f7ef4310c16115d65b70bbfd154a1bafb1c6807afc0cd89016f1a535858"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "24d1e9d985bf3a3088874ce859131a076809296e3c8d2788d585211c91d82a8e"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2cdbffb137eb41b7b5669d3d623bca5e139384a249de0b92b8071e82cd2fe7f"
    sha256 cellar: :any_skip_relocation, ventura:       "3b90afa49c344adab71a599b56ae89bec4c2e212a969a5c3c27776fee8dbfdbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af6ea7a3ecdc8143abd35ed4007fb1dbf0b90a626e3a2617028700388c22970b"
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
    url "https:github.comsignalapplibsignalarchiverefstagsv0.58.2.tar.gz"
    sha256 "694b8822364d2e5ea2cfe03e6be967db3de0922c8952d05e9407c92ed2d5056a"

    # Update boring to signal-v4.9.0b to fix build with newer LLVMlibclang
    # This should be removed after `libsignal` v0.60.1
    patch :DATA
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

__END__
diff --git aCargo.lock bCargo.lock
index 70eb3564..e733555c 100644
--- aCargo.lock
+++ bCargo.lock
@@ -349,16 +349,14 @@ dependencies = [
 
 [[package]]
 name = "bindgen"
-version = "0.68.1"
+version = "0.70.1"
 source = "registry+https:github.comrust-langcrates.io-index"
-checksum = "726e4313eb6ec35d2730258ad4e15b547ee75d6afaa1361a922e78e59b7d8078"
+checksum = "f49d8fed880d473ea71efb9bf597651e77201bdd4893efe54c9e5d65ae04ce6f"
 dependencies = [
  "bitflags",
  "cexpr",
  "clang-sys",
- "lazy_static",
- "lazycell",
- "peeking_take_while",
+ "itertools 0.10.5",
  "proc-macro2",
  "quote",
  "regex",
@@ -424,7 +422,7 @@ dependencies = [
 [[package]]
 name = "boring"
 version = "4.9.0"
-source = "git+https:github.comsignalappboring?tag=signal-v4.9.0#59883d7e23599f6631f9e5087db4b797f2953feb"
+source = "git+https:github.comsignalappboring?tag=signal-v4.9.0b#3d4180b232d332a86ee3b41d1a622b0f1c1c6037"
 dependencies = [
  "bitflags",
  "boring-sys",
@@ -436,8 +434,9 @@ dependencies = [
 [[package]]
 name = "boring-sys"
 version = "4.9.0"
-source = "git+https:github.comsignalappboring?tag=signal-v4.9.0#59883d7e23599f6631f9e5087db4b797f2953feb"
+source = "git+https:github.comsignalappboring?tag=signal-v4.9.0b#3d4180b232d332a86ee3b41d1a622b0f1c1c6037"
 dependencies = [
+ "autocfg",
  "bindgen",
  "cmake",
  "fs_extra",
@@ -1956,12 +1955,6 @@ version = "1.5.0"
 source = "registry+https:github.comrust-langcrates.io-index"
 checksum = "bbd2bcb4c963f2ddae06a2efc7e9f3591312473c50c6685e1f298068316e66fe"
 
-[[package]]
-name = "lazycell"
-version = "1.3.0"
-source = "registry+https:github.comrust-langcrates.io-index"
-checksum = "830d08ce1d1d941e6b30645f1a0eb5643013d835ce3779a5fc208261dbe10f55"
-
 [[package]]
 name = "libc"
 version = "0.2.158"
@@ -2963,12 +2956,6 @@ version = "1.0.15"
 source = "registry+https:github.comrust-langcrates.io-index"
 checksum = "57c0d7b74b563b49d38dae00a0c37d4d6de9b432382b2892f0574ddcae73fd0a"
 
-[[package]]
-name = "peeking_take_while"
-version = "0.1.2"
-source = "registry+https:github.comrust-langcrates.io-index"
-checksum = "19b17cddbe7ec3f8bc800887bab5e717348c95ea2ca0b1bf0837fb964dc67099"
-
 [[package]]
 name = "pem"
 version = "3.0.4"
@@ -4432,7 +4419,7 @@ dependencies = [
 [[package]]
 name = "tokio-boring"
 version = "4.9.0"
-source = "git+https:github.comsignalappboring?tag=signal-v4.9.0#59883d7e23599f6631f9e5087db4b797f2953feb"
+source = "git+https:github.comsignalappboring?tag=signal-v4.9.0b#3d4180b232d332a86ee3b41d1a622b0f1c1c6037"
 dependencies = [
  "boring",
  "boring-sys",
diff --git aCargo.toml bCargo.toml
index ed88b454..0a712b26 100644
--- aCargo.toml
+++ bCargo.toml
@@ -38,9 +38,9 @@ resolver = "2" # so that our dev-dependency features don't leak into products
 # Our forks of some dependencies, accessible as xxx_signal so that usages of them are obvious in source code. Crates
 # that want to use the real things can depend on those directly.
 
-boring-signal = { git = "https:github.comsignalappboring", tag = "signal-v4.9.0", package = "boring", default-features = false }
+boring-signal = { git = "https:github.comsignalappboring", tag = "signal-v4.9.0b", package = "boring", default-features = false }
 curve25519-dalek-signal = { git = 'https:github.comsignalappcurve25519-dalek', package = "curve25519-dalek", tag = 'signal-curve25519-4.1.3' }
-tokio-boring-signal = { git = "https:github.comsignalappboring", package = "tokio-boring", tag = "signal-v4.9.0" }
+tokio-boring-signal = { git = "https:github.comsignalappboring", package = "tokio-boring", tag = "signal-v4.9.0b" }
 
 aes = "0.8.3"
 aes-gcm-siv = "0.11.1"
@@ -122,7 +122,7 @@ zerocopy = "0.7.34"
 [patch.crates-io]
 # When building libsignal, just use our forks so we don't end up with two different versions of the libraries.
 
-boring = { git = 'https:github.comsignalappboring', tag = 'signal-v4.9.0' }
+boring = { git = 'https:github.comsignalappboring', tag = 'signal-v4.9.0b' }
 curve25519-dalek = { git = 'https:github.comsignalappcurve25519-dalek', tag = 'signal-curve25519-4.1.3' }
 
 [profile.dev.package.argon2]