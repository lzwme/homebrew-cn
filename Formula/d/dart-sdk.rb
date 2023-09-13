class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://ghproxy.com/https://github.com/dart-lang/sdk/archive/refs/tags/3.1.1.tar.gz"
  sha256 "85a376e98a22cd8ebccbb9f0e9289582800d59f8a41eeb6c282dabf03340c646"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f5fa85d10118b44e7a3d7d75081dbfc86a6048833678d9b0cfcb73f9fb0a43e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eec04446ab4df99ad9d5cccbe3819f5f36c732026bd45bb3968a15bbb9d661e0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "74f57e6377f06ee175f5ac9d93e26a4205d75ea1191485400ebb94d2ae8d7c6e"
    sha256 cellar: :any_skip_relocation, ventura:        "7434b6189d985e468ab009bc047621227b7aedff992acf688e8214f2f531efa0"
    sha256 cellar: :any_skip_relocation, monterey:       "9b2b2fc7a0d551e50603d59106bb535a30be9d6435a9e58653cc3f7214c4a37c"
    sha256 cellar: :any_skip_relocation, big_sur:        "1b1330429d5f632f7b463a585e2a756524b1561aa71cfb74a51a0896c50736ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd4046d7d419fef22d3194afe47a586dd0b804076469460184e25ef80b616bd0"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "8babcb7e2ec9ffe4e0394a66378423242dd66e6c"
  end

  def install
    resource("depot-tools").stage(buildpath/"depot-tools")

    ENV["DEPOT_TOOLS_UPDATE"] = "0"
    ENV.append_path "PATH", "#{buildpath}/depot-tools"

    system "gclient", "config", "--name", "sdk", "https://dart.googlesource.com/sdk.git@#{version}"
    system "gclient", "sync", "--no-history"

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