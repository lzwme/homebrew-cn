class Dartaotruntime < Formula
  desc "Command-line tool for running AOT-compiled snapshots of Dart code"
  homepage "https://dart.dev/tools/dartaotruntime"
  # NOTE: Using a placeholder file because the build source is fetched by gclient
  url "https://ghfast.top/https://raw.githubusercontent.com/dart-lang/sdk/refs/tags/3.13.0/README.md"
  sha256 "ff4301ec8e5c1259c5778c4abc947e303308cd31af30acd55575f5ca7ed6f405"
  license "BSD-3-Clause"
  compatibility_version 3

  livecheck do
    formula "dart-sdk"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b0fff5ba0f910bbdc7498a3a4e8a2235d9bd9a937b54c8ce3273cf339b940f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "575cf9527edd962a0ee63e249fdf2e48876c2074619ed712010a2a81719366e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86ae13989b2a5e0b95f03c121d2c62407eaa42bf6b044d709b2a9ca93f0b3620"
    sha256 cellar: :any_skip_relocation, sonoma:        "7de16acd7f768e36fc7bb42548d6604454d82ca9c92f3aac9dd251c102ded19f"
    sha256 cellar: :any,                 arm64_linux:   "38848b5c49a9c9944464b3b7587396eccd2649665cf0c3a3529549ddc1db364b"
    sha256 cellar: :any,                 x86_64_linux:  "eec67c3b3dc54959bc5db500f39f6087da146e6a0257025cd474921fde09bd8e"
  end

  depends_on "ninja" => :build
  depends_on "dart-sdk" => :test

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  on_macos do
    depends_on xcode: :build # for xcodebuild
  end

  # always pull the latest commit from https://chromium.googlesource.com/chromium/tools/depot_tools.git/+/refs/heads/main
  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "a1bda5b6167435ad0666191f0353f242104f5845"
    version "a1bda5b6167435ad0666191f0353f242104f5845"

    livecheck do
      url "https://chromium.googlesource.com/chromium/tools/depot_tools.git/+/refs/heads/main?format=JSON"
      regex(/"commit":\s*"(\h+)"/i)
    end
  end

  def install
    resource("depot-tools").stage(buildpath/"depot-tools")
    ENV["DEPOT_TOOLS_UPDATE"] = "0"
    ENV.append_path "PATH", buildpath/"depot-tools"

    system "gclient", "config", "--name", "sdk", "https://dart.googlesource.com/sdk.git@#{version}"
    system "gclient", "sync", "--no-history"

    cd "sdk" do
      arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
      out = OS.mac? ? "xcodebuild" : "out"
      system "./tools/build.py", "--mode=release", "--arch=#{arch}", "copy_dart_aotruntime"
      bin.install "#{out}/Release#{arch.upcase}/dart-sdk/bin/dartaotruntime"
      prefix.install_metafiles Pathname.pwd
    end
  end

  test do
    dart = Formula["dart-sdk"].bin/"dart"
    system dart, "create", "dart-test"
    cd "dart-test" do
      system dart, "compile", "aot-snapshot", "bin/dart_test.dart"
      assert_match "Hello world: 42!", shell_output("#{bin}/dartaotruntime bin/dart_test.aot")
    end
  end
end