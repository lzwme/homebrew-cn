class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://ghproxy.com/https://github.com/dart-lang/sdk/archive/refs/tags/3.0.0.tar.gz"
  sha256 "23b567fb89d3d2c23d50650991425ab2c9ef0911aeb3fad74538039455178191"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d212efa62703944ae68983e392f99339078c603db26b5da1e4cb12da7ade6487"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75620ae08dcf5b7e432f325d8d75e1b44ef9df7fd768ec91aed1ff69a1d4fce6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "297a7d249c6fa92801586cd229ce422665d28f569d04eb3c0958e7141825d190"
    sha256 cellar: :any_skip_relocation, ventura:        "97cef46c7f274d52130c94caf41b9667c6b2a014b3edafd5398b82a99bf1414e"
    sha256 cellar: :any_skip_relocation, monterey:       "d0fca66751cc65204b10a0154579213b063328d66c38f19c7ce2791ad8d0a30c"
    sha256 cellar: :any_skip_relocation, big_sur:        "2d96414cd356d1bfb0eb9c759fc5118bd0438d056b86bf34329e49c6dc8cfac8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9d8a9d9e9c57dde61a535ab0e9170e933f4626edbfd0cce892225b883edb8f7"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "24996afd00de79d33cea18204fc75ea6c0ad35c5"
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