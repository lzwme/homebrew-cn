class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://ghfast.top/https://github.com/dart-lang/sdk/archive/refs/tags/3.11.4.tar.gz"
  sha256 "3f96cd6bfc2b1fcdc6f512b5250e99ba14ead0c6d61f087f42197336d8eab5dc"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f6b414553f10ca0477cc6cb4722f796a8f209da0e1d91d90e29bdcbaf3f9fb79"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d1dec9eda8ff017c6428e1c2ea18cb8df6ea6e7b0f94d32b62beab5e2886581"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e9c798bdebbe115d2a2c408f3ea3362e25ae32a01589ddb1b6f3779e2aa4fd8"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3e414a09f65ad69a3b667224abd04e43fdc3d996c1fffd05b4ccb6f9b816fda"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20fd9ac1cb42af2c1df88ba879ced6b1bbfbeb2e1a24bb3e0eec48a006cbe27e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9da7043c34539062cc09bf40fd73663f31a8eaac794757d10117f6dd5e13848"
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
    version "4ce8ba39a3488397a2d1494f167020f21de502f3"

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