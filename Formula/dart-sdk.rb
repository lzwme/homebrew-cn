class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://ghproxy.com/https://github.com/dart-lang/sdk/archive/refs/tags/2.19.2.tar.gz"
  sha256 "30f49ed47a878834621d6703076b9fefab6390814fe6ff7cab2e19f5fccedb60"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d2cbc7e82185d58d02efab5daae0d71e092e35c94c655aa408319fa1c66c8536"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5b3855fd9c05d31b9a344a22ba46f419b7062c57625fa6c604b32da14782195"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "73276f47edcc01f115b6bc005036f58e16bd6c9445df3d3b0f565636adf7a4ec"
    sha256 cellar: :any_skip_relocation, ventura:        "2fa0f865d3267dbc311b89312776d10f0e495369a32da702c43cf434d40db757"
    sha256 cellar: :any_skip_relocation, monterey:       "24074b25f65eda34da21671363f9dc6427b0df58a9df90c35be040c7c233f189"
    sha256 cellar: :any_skip_relocation, big_sur:        "e6058433c574eae525f61a5b5b9b7404581c5b409b829787f15a2aef8e482870"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "262c3b529a9aa6d53fd3bfa0b18da651184224784a3077f22a019ab712f56489"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "d8fb7c966777733491e11037dcdb2bce1c16662d"
  end

  def install
    resource("depot-tools").stage(buildpath/"depot-tools")

    ENV.append_path "PATH", "#{buildpath}/depot-tools"
    system "fetch", "--no-history", "dart"
    chdir "sdk" do
      arch = Hardware::CPU.arm? ? "arm64" : "x64"
      system "./tools/build.py", "--no-goma", "--mode=release", "--arch=#{arch}", "create_sdk"
      out = OS.linux? ? "out" : "xcodebuild"
      libexec.install Dir["#{out}/Release#{arch.capitalize}/dart-sdk/*"]
    end
    bin.install_symlink libexec/"bin/dart"
  end

  test do
    system bin/"dart", "create", "dart-test"
    chdir "dart-test" do
      assert_match "Hello world: 42!", shell_output(bin/"dart run")
    end
  end
end