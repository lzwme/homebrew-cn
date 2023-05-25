class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://ghproxy.com/https://github.com/dart-lang/sdk/archive/refs/tags/3.0.2.tar.gz"
  sha256 "c77d27a59dc1ab5f5d497106061cbbeab264550d1667532cdd0e917ad54fb049"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ade14d29bd64b07c8a452e8821d185216de96cf303e88227cc80fd0287b45033"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72454e19d93b5f5885ed2a5ba61175daf45e10061c9b73b46be6bf81d918bfe5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3b3b078f7a382b6134ca0df54423ca7b1976594b789abde50e354da5e8dd1041"
    sha256 cellar: :any_skip_relocation, ventura:        "df89481f8ac5269307213641140f010539dcbead28d507de75da8fedac314faa"
    sha256 cellar: :any_skip_relocation, monterey:       "c85e1e5a649fb1f64bd38271a7c8b31419b77aed11c3e27867ed4a38df1be1c6"
    sha256 cellar: :any_skip_relocation, big_sur:        "4f72f44bc5b0e341de63a78269d30fe0e2ff3774e2b6278cf61a139b355c8694"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d54f8c582be71629b8923d8f8a27d802887314abe0723e00426ee01ae5250b35"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "85c13de0becd351c4ad2faeff8bbf88fdc74d038"
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