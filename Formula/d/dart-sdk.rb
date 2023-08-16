class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://ghproxy.com/https://github.com/dart-lang/sdk/archive/refs/tags/3.0.7.tar.gz"
  sha256 "afaffc72cc68aad63b76be1fd31a9708f8402c4d79013a4de9b082a6b1d40475"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "55801e0ac7796c5a023e4ed3bc00ed1c2bf6103f9b0ab389a804637758132f8f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72473a0be99f8c8fcbf1344bf0406926558d38a1a9377056dd131e36b3e03a8b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "361f6ddb377a8764c0752649e2475239983723c464be3dc2e4688bd013ad8efa"
    sha256 cellar: :any_skip_relocation, ventura:        "78d8f492b07202c284dada69dcf9f8d25f4b8daba41a46a8ff5dbbcf26107b5f"
    sha256 cellar: :any_skip_relocation, monterey:       "754aa0c8fb1f34d6d7eaa7d7f4dd8ebf91412c83077ccd2e562d0a58f4c02f43"
    sha256 cellar: :any_skip_relocation, big_sur:        "c58babe9dddf2bdec07979dcf1ef3010b393b15746d41682720e4f41a8458753"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6df6dd77cabc946e973a5ad19776099a5732ffb3f8f3b2f15844908410ab7a12"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "4ff51c15adfdd03b06cf842d5f18cab3f3868635"
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