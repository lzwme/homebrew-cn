class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://ghfast.top/https://github.com/dart-lang/sdk/archive/refs/tags/3.12.0.tar.gz"
  sha256 "c5eac0499935b6c13189a03d502a8e6aa0afa8c299a0458258d97f4234ccf512"
  license "BSD-3-Clause"
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "96ce56dd2a090c44eb7e293b4d46f0100616660d3613bf9e3fb526bd915dc395"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8cd66bd28f7d966978c097dffc27f4982c7f3c0f74f09098e08fc3f41c6370ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78ded9508e309c2a291bf197bd4e34ecfad67b131c9211807b6cc3190ef93e64"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e87c4a42ce89e36fce9d480b4ea42ba1254b8e8d50834de4251b2efca7a528b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "009693145a96f7083512c2f7a1c546671bb84c2a9c17c172643f7c5781b4ae06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd8f4ebf10ad79876dcf9cc1a868fb6a934ab00c645e4386b6d2147cdc86c0dc"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

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
    ENV.append_path "PATH", "#{buildpath}/depot-tools"

    system "gclient", "config", "--name", "sdk", "https://dart.googlesource.com/sdk.git@#{version}"
    system "gclient", "sync", "--no-history"

    # Workaround for dependants audit failure: Libraries were compiled with a flat namespace.
    # Issue ref: https://github.com/dart-lang/sdk/issues/63115
    # PR ref: https://github.com/dart-lang/sdk/pull/63116
    inreplace "sdk/runtime/platform/mach_o.h",
              "MH_NO_REEXPORTED_DYLIBS = 0x100000;",
              "\\0\nstatic constexpr uint32_t MH_TWOLEVEL = 0x80;"
    inreplace "sdk/runtime/vm/mach_o.cc", "MH_NO_REEXPORTED_DYLIBS", "\\0 | mach_o::MH_TWOLEVEL"

    chdir "sdk" do
      arch = Hardware::CPU.arm? ? "arm64" : "x64"
      system "./tools/build.py", "--mode=release", "--arch=#{arch}", "create_sdk"
      out = OS.linux? ? "out" : "xcodebuild"
      libexec.install Dir["#{out}/Release#{arch.upcase}/dart-sdk/*"]
    end
    bin.install_symlink libexec/"bin/dart"
  end

  test do
    system bin/"dart", "create", "dart-test"
    chdir "dart-test" do
      assert_match "Hello world: 42!", shell_output("#{bin}/dart run")
    end
  end
end