class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://ghfast.top/https://github.com/dart-lang/sdk/archive/refs/tags/3.10.0.tar.gz"
  sha256 "cfe5b2121a686c423693112adb1deba2bcce3f53c89e4fa3bc7af5f8e0a60731"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c7aae87cf76e01f1da34888e1db25d8232db35cfaa10f11da2f97f9173a598a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aea62fc9120c253fa231af826c083fbb798018709135c1f84cee9a7e3f7ff066"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e86361ea9758c026dcdd4bd0132e59c72f81dc6c616b89054318a9d4014de991"
    sha256 cellar: :any_skip_relocation, sonoma:        "afa32c2aa1cbe73c4527e781fb817fb8c8f119e0cac69ab4cb4cb3bce4b0ecd3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "740e0234583fb938c4c7a8d736feb216d28f80a68ad37c5b224045ae12a39e17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6451d2e5dabd031b6536db55569ba52c8e0a087392a0f1fd6631e51053c86af7"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  # always pull the latest commit from https://chromium.googlesource.com/chromium/tools/depot_tools.git/+/refs/heads/main
  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "2bc167bbcaf08963097999f670045b451428c4b9"
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