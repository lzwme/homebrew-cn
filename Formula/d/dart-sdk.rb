class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://ghfast.top/https://github.com/dart-lang/sdk/archive/refs/tags/3.11.1.tar.gz"
  sha256 "b7ba1476aa4d3930eb81a3ac9a86dd0c23d2963142addfbca80c505165824a71"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d2f38e4486505d7a86cd10cf68b3e1da2632c931514fdd8711555204b09d6b07"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "770e0d4c785b7e4c9eb484437ad23b617c5bb145a0e4e1d7d9c2e23492246966"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92a388bf6ef3a69ba09900e87aee963bd5bece9748319e4b7d5f4c586fbd206d"
    sha256 cellar: :any_skip_relocation, sonoma:        "54626812ca058189ea8e11a2725b432e73b5d9cee4d3cefb01e5230e76d490a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c674fbf66f49aab4bd1cd70144eede9c2802b713b727d11aab5049ed4dbf6ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70694c30a1123a967e7b36571b2b9c3e569da73e8ad2ffd0a5c1d789bd4caee9"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  # always pull the latest commit from https://chromium.googlesource.com/chromium/tools/depot_tools.git/+/refs/heads/main
  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "8aad2863865f0d0bde8b2eb804b389412f04a38b"
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