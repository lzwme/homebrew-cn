class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://ghfast.top/https://github.com/dart-lang/sdk/archive/refs/tags/3.11.2.tar.gz"
  sha256 "570097d227e9bb48aa71a81df9d6613a53ee26051bddb33784b01fe13aa5c46c"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ca91c09c63149b7e5af71b60305962ed52063a3a99eb7318860f090d9ce4f8c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "833b7d3785bac8331dd8c66a362aab0c2148826272c6bd3a769fbd93bc13f1ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b14ebb9957c6f1591848a6e4b6fd86bff21486295b993a7b6f506d73ff0de2f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e7e3950bd8abeff64749e1aa53d930e7b9c8a21fd57f1a9c53ba7cc900c4d32"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f21d0c8309202d4ce8b436335972a6c121e385a6f2957d147952c6e96826176f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0857e1ea27b6260c0a23082724dc373d20f271d626e41f2913b0e01ded4a4f4c"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  # always pull the latest commit from https://chromium.googlesource.com/chromium/tools/depot_tools.git/+/refs/heads/main
  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "4ce8ba39a3488397a2d1494f167020f21de502f3"
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