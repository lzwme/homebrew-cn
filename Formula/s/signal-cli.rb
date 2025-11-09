class SignalCli < Formula
  desc "CLI and dbus interface for WhisperSystems/libsignal-service-java"
  homepage "https://github.com/AsamK/signal-cli"
  url "https://ghfast.top/https://github.com/AsamK/signal-cli/archive/refs/tags/v0.13.21.tar.gz"
  sha256 "3b751f8989a48a0d39c87d349d311541ba3ec286f7fb8de752596c4d07788728"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5645f9fd9aed02e08b2ba8a53ed1f5e3c33de7c6404e2f75cba49d573a0a15f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e6f23e94eee81c011334abceb4d60669d75658258e11be9aefd0c422950bb7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3874d9a53ce902709dc3decf1617a0077cf231eb6e2097df8327cfaf217935b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "643939445d196116def3fe68f8ed63e97cff64bad302f9ba355d3f493e516140"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2604048edafdc9f3e992e7b1c03d2494c0ed6de457a6787735341f3cde7c476"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aaad9e9049271e4d9ccb20f6ec8b54ed72f114904a6b12aa8612fc80fa16e3f9"
  end

  depends_on "cmake" => :build # For `boring-sys` crate in `libsignal-client`
  depends_on "gradle@8" => :build # older version needed for `libsignal-client`
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  depends_on "openjdk@21"

  uses_from_macos "llvm" => :build # For `libclang`, used by `boring-sys` crate
  uses_from_macos "zip" => :build

  # https://github.com/AsamK/signal-cli/wiki/Provide-native-lib-for-libsignal#determine-the-required-libsignal-client-version
  # To check the version of `libsignal-client`, run:
  # url=https://ghfast.top/https://github.com/AsamK/signal-cli/releases/download/v$version/signal-cli-$version.tar.gz
  # curl -fsSL $url | tar -tz | grep libsignal-client
  resource "libsignal-client" do
    url "https://ghfast.top/https://github.com/signalapp/libsignal/archive/refs/tags/v0.84.0.tar.gz"
    sha256 "eb68997586ce8a0f3bfcb57a35b3bab9e45364e371dd37d0d55ab28f3a9671a2"
  end

  def install
    java_version = "21"
    ENV["JAVA_HOME"] = Language::Java.java_home(java_version)

    # FIXME: find a better way to handle resource version check as this can easily break
    regexp = /^## \[#{Regexp.escape(version.to_s)}\].*\s+Requires libsignal-client version (\d+(?:\.\d+)+)/i
    libsignal_client_version = File.read("CHANGELOG.md")[regexp, 1]
    odie "Could not find libsignal-client version in CHANGELOG.md" if libsignal_client_version.blank?

    resource("libsignal-client").stage do |r|
      odie "#{r.name} needs to be updated to #{libsignal_client_version}!" if libsignal_client_version != r.version
      system "gradle", "--no-daemon", "--project-dir=java", "-PskipAndroid", ":client:jar"
      buildpath.install Pathname.glob("java/client/build/libs/libsignal-client-*.jar")
    end

    libsignal_client_jar = buildpath.glob("libsignal-client-*.jar").first
    system "gradle", "--no-daemon", "-Plibsignal_client_path=#{libsignal_client_jar}", "installDist"
    libexec.install (buildpath/"build/install/signal-cli").children
    (libexec/"bin/signal-cli.bat").unlink
    (bin/"signal-cli").write_env_script libexec/"bin/signal-cli", Language::Java.overridable_java_home_env(java_version)
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