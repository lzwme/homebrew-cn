class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://ghfast.top/https://github.com/dart-lang/sdk/archive/refs/tags/3.9.0.tar.gz"
  sha256 "948e4244fa0e9ec7acee5cd40d34f6250be484effae5059d67290c82e3f45099"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c08b1d46d2c7d15f359dd9e49e24f7bd235e773853c1282c354a34711aa397fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84c93ad7cbb2d802725f175f4dc9964b0494a45dab3906d7115135d817d70896"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eaeae7dfe3c5027b25fc4bcc06a178d4d9ff13014e69c8a73bdf2ea7973d5c71"
    sha256 cellar: :any_skip_relocation, sonoma:        "23c8ec01e645844d941c6a181bf5aafe8eff2a16cb1eecd9ac518e23174d397a"
    sha256 cellar: :any_skip_relocation, ventura:       "fa9b3ab24452ce7219dc1e15e349c5b542bdd358e351db84e34b89ca35cea8dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa32eb5921b401d994ae96b910f6f89ff6fd715e5493b279ae46f4fac55ae7aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2bd5d20b5fd6eb425c286ce06a1d08eacb37efc80b320935237932fbd0eed4d"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  # always pull the latest commit from https://chromium.googlesource.com/chromium/tools/depot_tools.git/+/refs/heads/main
  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "b12a6cc03cf7838d3ea320a5a8b0c2c8d4a6151e"
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