class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://ghfast.top/https://github.com/dart-lang/sdk/archive/refs/tags/3.10.8.tar.gz"
  sha256 "240859c359fbcc116f52648a56986befca0ffe576573bd45f1a6b7ff0d030403"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "06dcf557e66ee95770aa0cb92e1f51dbd29974fc361b6ce743976f05c5395948"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37f0e4622494e0c49c1149d60d4942c6cad1994379065d2dacf56db333951fa5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48affd6cd0447e7f3629f8cc710c0860954e5ba7485c74026c34a32e44f4a19c"
    sha256 cellar: :any_skip_relocation, sonoma:        "c92517c5bae0d220357336ecf21d92b94e573a729b7904090b315d838bb1d543"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80c2e03773e188c4dfe308cdef4fa584657d4f42516da226cf57570c1224c52c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee689d3887428758263df849bb973d1efcd57a16616574f6285246e4e2a2c6f3"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  # always pull the latest commit from https://chromium.googlesource.com/chromium/tools/depot_tools.git/+/refs/heads/main
  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "ec7d8f539cb439ce9ca7750ff0d8942e68325090"
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