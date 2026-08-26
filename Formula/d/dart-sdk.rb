class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://ghfast.top/https://github.com/dart-lang/sdk/archive/refs/tags/3.13.2.tar.gz"
  sha256 "e44d88417ebac2037ec26e06bbda2ba00f2dfb60c4fcf20191a5b1f8a9fdbc03"
  license "BSD-3-Clause"
  compatibility_version 3

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d9f1bda855ffc70d29ed75e9ccef9c2b40d296cc8f986897b3bd40f94ee04854"
    sha256 cellar: :any, arm64_sequoia: "45ca22e65665a459ed0c9952ee7930916bba78cb025fda4b10bdb5859fead141"
    sha256 cellar: :any, arm64_sonoma:  "e9fa642ddceec513f1de8ff487ec33e214f9bff885a8a057b9baf4b7ef39adb6"
    sha256 cellar: :any, sonoma:        "fb06ffb3e282b4692f21275135da2682859320fe06f530aa07a5bbdb9dd6a301"
    sha256 cellar: :any, arm64_linux:   "1c19b600073637453512ad1861a02c77c19d9e25a7bf962c6a5577f0fd19c61b"
    sha256 cellar: :any, x86_64_linux:  "115158494c0f736cd9a83a52b71b3bffa720b9e0669b8806e4f50a579868000e"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

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
    ENV.append_path "PATH", "#{buildpath}/depot-tools"

    system "gclient", "config", "--name", "sdk", "https://dart.googlesource.com/sdk.git@#{version}"
    system "gclient", "sync", "--no-history"

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