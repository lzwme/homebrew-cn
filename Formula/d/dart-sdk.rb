class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://ghproxy.com/https://github.com/dart-lang/sdk/archive/refs/tags/3.1.4.tar.gz"
  sha256 "8899e404e4e6943d087ae6ce26adfb9211f0c266a172708c8deb33bb5d69be59"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2487ff7c48879ec3e8858b3aa6d1fdd3ec5d0b04001b6c1f174b2346b87c3cb4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fab018ad24102ec1ee63fb5ea36a3ba59fd3703f1b752add22ca76df303ddd81"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49b3e954e00daa5fc569bcaf1945f0a4028c61ad8f277f8ca6b30e04d1b8cfc9"
    sha256 cellar: :any_skip_relocation, sonoma:         "11ad43d0afd695063ef6fdfcb4df9107a9cf6040165dfc74ce0f88afd1ca83f7"
    sha256 cellar: :any_skip_relocation, ventura:        "b10cd5d33c89d8699d98704cc03f1033d674ee897c033b0c729567e295a92c40"
    sha256 cellar: :any_skip_relocation, monterey:       "7a297bfd8679f82dbf5f2b9fc1cc3b96be6bda75277e04a94f36cb74c9afe5b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfe4b34ca0c3eccb53ce6a234f8253dfde80f7e6a8bab2369b828294507a1f16"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "406be8281e32743a86df7c855ba608739e812dea"
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