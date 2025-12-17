class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://ghfast.top/https://github.com/dart-lang/sdk/archive/refs/tags/3.10.6.tar.gz"
  sha256 "a3522f9ad40ead5f3c572628809ba0859c62455b50b261c502aa9a1a6f941fc4"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "96c7dbe9219ea63e20b714c67f1d6f452790e9e7f3e6607d8a81578e5f5a14f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6c7dc32bab383b564fceee7bff2507d21ebdbe32f071dc1cca08c1959eaf90d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5389ddf759390213eeaa44c54df56b4accfc40f568d2ef26a257bc7bb8c8dfc"
    sha256 cellar: :any_skip_relocation, sonoma:        "8823ca57156e548bef05cdf65970a2550ed5d520e14199862618c52a598199bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "330b75412a316acfd2c12dbdcbe9f3bd57964b2854497fe84595de39f1e37bc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8bd6683ae4cda8bd3b210d0fab1fcbc0501c6a9abe4ab47e37658b96ba3eded"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  # always pull the latest commit from https://chromium.googlesource.com/chromium/tools/depot_tools.git/+/refs/heads/main
  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "276d76ecbd54e05ef902c23eb3a322bffcd9fa8f"
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