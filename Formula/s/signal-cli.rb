class SignalCli < Formula
  desc "CLI and dbus interface for WhisperSystems/libsignal-service-java"
  homepage "https://github.com/AsamK/signal-cli"
  url "https://ghfast.top/https://github.com/AsamK/signal-cli/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "fe45bf77a3dd735aa677b24c88c5b6d6af653ed9d844d5bd79e5a1f264cd2d32"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "39e28036bb03d792b0a3f891c2eab7d74e8632a8fdbae1c59e4793ccabaa18e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f4230823f30d45571c8bc4f6ccbae6403d54f68f22c3799cc02c5ff29972090"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74d0f1975626cee7d735830b4fb25089824d837f63a4a8ad9d89be2f0ee05000"
    sha256 cellar: :any_skip_relocation, sonoma:        "9021362c064898007458cda647a9b4cced36317e0fc8763b43765b433e650390"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1d5baed4fb49796eda01801b3e58e7dffe787108d89872e815c848b5a2ad026"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bad8ffc1d4bf6af50552f5bbdc01e520961f55c8c8038465fb02236cda422184"
  end

  depends_on "cmake" => :build # For `boring-sys` crate in `libsignal-client`
  depends_on "gradle" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  depends_on "openjdk"

  uses_from_macos "llvm" => :build # For `libclang`, used by `boring-sys` crate
  uses_from_macos "zip" => :build

  # https://github.com/AsamK/signal-cli/wiki/Provide-native-lib-for-libsignal#determine-the-required-libsignal-client-version
  # To check the version of `libsignal-client`, run:
  # url=https://ghfast.top/https://github.com/AsamK/signal-cli/releases/download/v$version/signal-cli-$version.tar.gz
  # curl -fsSL $url | tar -tz | grep libsignal-client
  resource "libsignal-client" do
    url "https://ghfast.top/https://github.com/signalapp/libsignal/archive/refs/tags/v0.87.4.tar.gz"
    sha256 "76b7e851475846e33c1dd0a95d60806a7db001c0911f28ff8903843a22ea8adf"

    # Workaround for gradle 9.x
    # PR ref: https://github.com/signalapp/libsignal/pull/653
    patch do
      url "https://github.com/signalapp/libsignal/commit/88cd7aa21e1d8db12188c8126f87d47182ae4d6c.patch?full_index=1"
      sha256 "2c37d16b01cfc4bb62a56c6e8c3ba762c47affdcfc983bb33f5510eb99124d72"
    end
  end

  def install
    java_version = "25"
    ENV["JAVA_HOME"] = Language::Java.java_home(java_version)

    # FIXME: find a better way to handle resource version check as this can easily break
    regexp = /^## \[#{Regexp.escape(version.to_s)}\](?:.*\s+){1,2}Requires libsignal-client version (\d+(?:\.\d+)+)/i
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