class Dartaotruntime < Formula
  desc "Command-line tool for running AOT-compiled snapshots of Dart code"
  homepage "https://dart.dev/tools/dartaotruntime"
  # NOTE: Using a placeholder file because the build source is fetched by gclient
  url "https://ghfast.top/https://raw.githubusercontent.com/dart-lang/sdk/refs/tags/3.12.0/README.md"
  sha256 "ff4301ec8e5c1259c5778c4abc947e303308cd31af30acd55575f5ca7ed6f405"
  license "BSD-3-Clause"
  compatibility_version 1

  livecheck do
    formula "dart-sdk"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "51ad9f08233aba9637bbfea708f440c7de5fb4d98134b5d0b740d7f98a29c3b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4789786214db550f3c9d2f466598b09f41aeaf069f1928daccd5a7ba3135611"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "943a9e80515827e050ab78710ca57aad243496fcc0e6d95b193d6612a07c30e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa2209a1f50707214b543ae928f5e7ad71324b67f86940f3b7646be27372817f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6425b9396535ddbfc9b70a6e331a6cfa45a2780b95d6c2aec104453bfda792e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a649b57b4da073c2063058a2cd7a5b2789e319a5aa12579057bc523b31d0cf0"
  end

  depends_on "ninja" => :build
  depends_on xcode: :build # for xcodebuild
  depends_on "dart-sdk" => :test

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  # always pull the latest commit from https://chromium.googlesource.com/chromium/tools/depot_tools.git/+/refs/heads/main
  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "b9d2b54daea64fa757df5ba737e611b691dc6201"
    version "b9d2b54daea64fa757df5ba737e611b691dc6201"

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

    # FIXME: Workaround for https://github.com/dart-lang/sdk/issues/63089
    if OS.mac? && MacOS::Xcode.version >= "26.4"
      inreplace "sdk/build/config/compiler/BUILD.gn",
                "\"-Wno-tautological-constant-compare\",",
                "\"-Wno-tautological-constant-compare\", \"-Wno-deprecated-declarations\","
    end

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