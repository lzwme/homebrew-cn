class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://ghfast.top/https://github.com/dart-lang/sdk/archive/refs/tags/3.10.4.tar.gz"
  sha256 "61140ab9d277f77b84a36d8269e91c9296030b8954f07a8df0c6394343b8dd01"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd4221a5e0f8eea99d6e8390ce66e64bb9e53750f735ef4b15aa001f7f30799a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10f5f4da4cd7c2bcc978bb0499c016bff7ef2cff6c8e43c0a296c4779a0f455f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9eae5c7be17524aa4f3228178e4aa73e5fee434a01b1b86065241f7ef57a0499"
    sha256 cellar: :any_skip_relocation, sonoma:        "efb7993dd17dc00e646188eaa58c70517b4280cc4c136fc6f37f614d3381f44f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2772347a65f1b9c8e7cf9b4bbc631cc74c804f7d2724ddcc1f10ed850cdcf5d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "754cd6cede6ba86a897a1a76bf1dbd96d2e9df59ee56f13279801d60c4f8e529"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  # always pull the latest commit from https://chromium.googlesource.com/chromium/tools/depot_tools.git/+/refs/heads/main
  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "6cd31a3b571f8b686273ebd0fcaf9cb368158984"
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