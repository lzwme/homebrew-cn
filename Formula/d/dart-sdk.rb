class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://ghfast.top/https://github.com/dart-lang/sdk/archive/refs/tags/3.10.9.tar.gz"
  sha256 "6ee0eb28f514863186a16aaac104f4ff7259ee336dd226d63e68d438ce76cefa"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd6a2b40c04613362f69fdd55daeb1493c1855ec425c112f55eddb674c1f07b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "850e2e0000da69af2c4efaf6e5406f6efae3596d718e0ff39347cf9e139e6dd4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31b9c51b41866554180bd57cf6112ba224ee180a3b3ff6ca922fd063208a21dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "19e50ac9ff35f000328f79c29b7491340af96f42cf94f2b8bc88f6756948a5f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f71e58ae7fb7884b6f65584638c76bf2f1a5b235a0724d5dcca9166a887566c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5096dc1827faea662b63166f0c321710333926e122c9521d8238c7146b1c4db"
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