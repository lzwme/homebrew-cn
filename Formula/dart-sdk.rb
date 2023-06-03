class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://ghproxy.com/https://github.com/dart-lang/sdk/archive/refs/tags/3.0.3.tar.gz"
  sha256 "c626cabd7840378f3d7b4b14eb70b6ea81034e92e8efa9cd0e1cd07f51612512"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2f2dd4b3d335438d775cba9b2170b6992d0985c57d853ede32c6aebddc0f20e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0fc54e8a64ec758344ebf499294d511637be571bebb083ac289bbf5d425cb151"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9629c1cf843a314077005789f181bb6c7b3a3ea6d2a010712805c0f13eae4da3"
    sha256 cellar: :any_skip_relocation, ventura:        "fe31bd4f332b2ff401c0005c2a0d26265eeb450efaba5d30a7ad64b89dfe8637"
    sha256 cellar: :any_skip_relocation, monterey:       "eea26f6a956f2b3d53b5f22ef5ea066c4a313fad990f70c8a0fbfdf0399565b7"
    sha256 cellar: :any_skip_relocation, big_sur:        "63f0b304855675f0f11c6ccf3c91c1fbf587a6c5901179e7184074e817cb3768"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c06b14f4552483d9562b824fde9df620323c132c03cdd3790f36549b053c6c93"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "9e0ff22bfb3137e9c6b44304671a78c3e3d1e1d9"
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