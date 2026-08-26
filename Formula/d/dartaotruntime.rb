class Dartaotruntime < Formula
  desc "Command-line tool for running AOT-compiled snapshots of Dart code"
  homepage "https://dart.dev/tools/dartaotruntime"
  # NOTE: Using a placeholder file because the build source is fetched by gclient
  url "https://ghfast.top/https://raw.githubusercontent.com/dart-lang/sdk/refs/tags/3.13.2/README.md"
  sha256 "ff4301ec8e5c1259c5778c4abc947e303308cd31af30acd55575f5ca7ed6f405"
  license "BSD-3-Clause"
  compatibility_version 3

  livecheck do
    formula "dart-sdk"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f9a11b5904f2895f1fc88e38e75321310a9632188d34e57b43c7fa377ea0b0f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3442db62a853db0532be4795be25e918d5540c6ccccb194185d5034126efaf0c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2c3c811d72ccac45cea76318cc6aa99ecce1f5783d8bc8629d34b7f2a5fd1f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ea091ed5f2a6e2bd3a466f327ba445f54aca6bb8b37450ea67f5481e98dfed0"
    sha256 cellar: :any,                 arm64_linux:   "48a8b69d174e8ff5038966437813d3d2c7776af8a6b1afee786d2e1873afe08a"
    sha256 cellar: :any,                 x86_64_linux:  "fc4290733c513e269e73c4f181182f55aa65c319b87b23a1a9532cdd885d2a2e"
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
        revision: "8ff4a322a17ea014561931720c8153904cd0a9c3"
    version "8ff4a322a17ea014561931720c8153904cd0a9c3"

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