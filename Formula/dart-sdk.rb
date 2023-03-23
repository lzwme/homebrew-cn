class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://ghproxy.com/https://github.com/dart-lang/sdk/archive/refs/tags/2.19.5.tar.gz"
  sha256 "ccd347f61810bef153ca1dd55168207852ea73fc86ae55111c6e8f8e307dbbfa"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ceaca095f71c21280bf2ed1bd1f1b8550b9fecd17931bb92c94ce93b0bf25131"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96ad679de8c7a75a3b5342f6601eebebe80854a955dd53af79b327a22fd63225"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "53fc593f871fc8fba056a03a9ccd7829a3172228c01bb3d45402a6c925101813"
    sha256 cellar: :any_skip_relocation, ventura:        "13944a74a597a72259673bb9a43030158a6071d915195007ffc374792c03f7fe"
    sha256 cellar: :any_skip_relocation, monterey:       "9a15fb886b3ce9852ba7d462c3f98dc10d45581aa53e4ea0e6601454f6f40727"
    sha256 cellar: :any_skip_relocation, big_sur:        "9af6adb1b35c79dc7d4b76848ee2bbf82839c913c14076395ecf1c797d978a55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22fe7237c7c59cd3c65648ec076524a7b8061d6fea8d64c6e49f8c033c880d95"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "d4c6cbeb61f3be41476de5ce984ec528d8209e88"
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