class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://ghfast.top/https://github.com/dart-lang/sdk/archive/refs/tags/3.13.0.tar.gz"
  sha256 "89a06c61c4fd29dccae6ba48e86141dc94b867cb1c0ec021175dddc0720a0747"
  license "BSD-3-Clause"
  compatibility_version 3

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "11663e272ed070a4752092aa1ce19ab1b6eaaadaaf010254dd2b21987a95e227"
    sha256 cellar: :any, arm64_sequoia: "0e7d370c0ffaa06ca912a1c88d9fee83200db6aa38a815731947669b469589af"
    sha256 cellar: :any, arm64_sonoma:  "451954034a5ec19d18c9b99ff4a9ab2588ea7f1acb8f31c9d08fe10d541618b5"
    sha256 cellar: :any, sonoma:        "ecf9d5b96efcc4424c0b0e6830e6906a33c3ffc83b8f6a497094806b633d0b62"
    sha256 cellar: :any, arm64_linux:   "a6be416717e30612378fd2e9f7c122ea72f1d577f3fea1e168a4dbb60af5a6f9"
    sha256 cellar: :any, x86_64_linux:  "a7d21268e56c7526026b69d5936814bd261b19ec846e47b844a19bf3b0cb79b2"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

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