class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://ghfast.top/https://github.com/dart-lang/sdk/archive/refs/tags/3.9.1.tar.gz"
  sha256 "16b2e9c2e8208395f1f8a775446a2deca803ebd38388bcf637219797ca1da930"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c69fbfedff6e6d6fed21921c0f8f2b0b136cb0b587309ea6431861d0f6a17c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "489163a4dccdd73161e9bcfc1cce7d2b56eb68d766568da3ff0300161222737b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "87796167b84a9e12b9af0bbdbcc4c07fdb806a5d4235f3d460861f59d962c05c"
    sha256 cellar: :any_skip_relocation, sonoma:        "09dd1a5468511fd3c169aa40077309b47612ac42f7cd54f30754717d393440a2"
    sha256 cellar: :any_skip_relocation, ventura:       "d4278d7c624fca5a1c14f92aa2ad22778093aa135f8f0269c4c62855c0163c9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80a5d06bc2ae2fbb32569f6e9433b9a9a447465ecad54e131d96766aa24c8078"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10b844a78bdc31d1498cb3eda0d5a9e1afd35d265c79b4b9496066a62c3334d6"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  # always pull the latest commit from https://chromium.googlesource.com/chromium/tools/depot_tools.git/+/refs/heads/main
  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "fad3730e80171ce2723a48f4cc08682c6f19d640"
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