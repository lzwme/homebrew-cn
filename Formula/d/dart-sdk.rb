class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://ghfast.top/https://github.com/dart-lang/sdk/archive/refs/tags/3.10.3.tar.gz"
  sha256 "8976642947a893214399cd039c4ceb9cfe9a7cb0de011a174c6864724fc8158e"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "14467880613fb5186111123bec4deeac25b9cce542c513ced8cc087c2bd34558"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "702b5a27dd7680dab4182b38cb8a8870d8ac8f843a1419a4bb7d6b39dc3737fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50b53fd9648aae2d3305ca5861c0629d984cd10a9a9ebb5fa15b3030d558fbc2"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca127858a36270d983f4a53487e0bd9e17e105a34c8170a5782d8731abd465ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0a121a3749a0d684bd4db4d422768be91beab4015757e4ea093c620bd62ada7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "262971b75021f4366970c429397ab75d35d5220f8c380a9b4436ccb6fc4ab6ee"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  # always pull the latest commit from https://chromium.googlesource.com/chromium/tools/depot_tools.git/+/refs/heads/main
  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "db99cc40f562179c59f12b10e8af2d8fe2770ad2"
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