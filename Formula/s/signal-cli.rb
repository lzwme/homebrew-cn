class SignalCli < Formula
  desc "CLI and dbus interface for WhisperSystems/libsignal-service-java"
  homepage "https://github.com/AsamK/signal-cli"
  url "https://ghfast.top/https://github.com/AsamK/signal-cli/archive/refs/tags/v0.13.23.tar.gz"
  sha256 "bbb617dbf286a842b34f0c8dfe4f7f38e658461a854b779457a1358151286afb"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e07a6e75711da7f54801b7c1dacacf68e0442adf0e8525fe203da7bef67e75f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e07789f2da84021258a60f01a52688705649d9a006d5ff7aa3e334328f2b866"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a87512db8f1e6103999f74cbf327df2cf87f41534d2ebad2b69c3aa76bcf27a"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f5c9016aa2452979031523e773fb0bc5b808f86fad09f2597b78ed3a977d4e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91e97d266344de898947249d7df17a030ef4d9b5e668b7727fb3ee84ecefbf7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0071e63f25dbf0478b7bc9d11967cf2c9a8c782771dc6f261d9cb214917db842"
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
    url "https://ghfast.top/https://github.com/signalapp/libsignal/archive/refs/tags/v0.86.12.tar.gz"
    sha256 "d9dfe3c29674e1524689c12d7c27074ea6d98ff52fd428b1c7d2dfa98f07cbda"
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