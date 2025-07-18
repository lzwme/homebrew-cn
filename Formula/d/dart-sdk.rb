class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://ghfast.top/https://github.com/dart-lang/sdk/archive/refs/tags/3.8.2.tar.gz"
  sha256 "470dfe235da89b023afd6d97ca629be6450b23c25756955efe9915018a3953e1"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b1a1a44dd7338e08d20bea877e0604cc63c8d9efae318577d8c341208d18717"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "662eaacf4052a68fb6fad4d7ffd3d0cc05362e357c94cf211cfcb40a16f2cb5a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5563f14195da4a8651052a5fd78a0729ade81583ddad28b8e23b2565259d7328"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff784c541127147c607e67452bae7afbb6abb9e601612cca1e7bd1718999c94c"
    sha256 cellar: :any_skip_relocation, ventura:       "51b2ff36aad64fc2a7a5cc97a3e90922585e92dabd06e0d559bbfa02f5f331c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4de3176da07d4708e3d78ce3250af63fda80c3a61575075b3c64355bfca5b218"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c71adafbe35c53afce6d8b7e155b032315e443c22530b30987bd2a4cebfc272a"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  # always pull the latest commit from https://chromium.googlesource.com/chromium/tools/depot_tools.git/+/refs/heads/main
  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "0b1d80ab9e9f1413234641d193639e5daa92dd5b"
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
      assert_match "Hello world: 42!", shell_output(bin/"dart run")
    end
  end
end