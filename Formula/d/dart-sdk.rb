class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://ghfast.top/https://github.com/dart-lang/sdk/archive/refs/tags/3.9.2.tar.gz"
  sha256 "facb0069a820264b4e7c3d60dcc36226b50bbe288e2364e4b2b150de9d6d28b8"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "326ab60a1ff719140362f66a8740e4d8b88c144c5edc78a4f9937e2995d3500e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "caf4221b2bf002b25e78bacd59ae50550c1995e8d023a35db8385bea373c1f7d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "49ca137e60df3920aa2c9463893d2fa596a33f6f8cbb51156644065327a95f58"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5bceff20b2626902bac7c372965dda71e56ca1ca1f3867ced8366f9afe7b86c"
    sha256 cellar: :any_skip_relocation, ventura:       "50056a921c5ce97a91153141b465c8033649fca5bbebf5cbac9bd9af0554cd30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f15c894c9d565349e8d97398c08a0959597d70d686977d78d9a5f754e82f2451"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d576359b862a9ce75fbaaab7307e5aacc2746394d96df67531f85fa25ea17779"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  # always pull the latest commit from https://chromium.googlesource.com/chromium/tools/depot_tools.git/+/refs/heads/main
  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "c3749b59b3f421ba9f29003d4e3d509ed372467d"
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