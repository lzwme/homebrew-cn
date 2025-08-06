class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://ghfast.top/https://github.com/dart-lang/sdk/archive/refs/tags/3.8.3.tar.gz"
  sha256 "29dd0a9be41eb696f8c45ac9bde7c1f0f2884b4e454ab06a137c7f145b58c1f1"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0590c5e3cf59332a0cb0d019e24f98cd9e017ec4cc451cde849771545ab2c1b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "efb0155f2bfe3b275241a6bb0e954e5cf69e2c4046ac5980f034602a5ed4eb39"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c47365c5400ec2915c50f4fe04f94f624ba49c4fa55dc04bdbcefb38a0b3e20a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0c500d0f1aef95f8d6d050eb5bb4156c4194286fac93114cd97c0d2d0712d0c"
    sha256 cellar: :any_skip_relocation, ventura:       "26c208bf97b02f33bcceeb76bd5ff5a63e757bfc7a9cae1fd14461759b92cec6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8580158c55ce1a728cc8a859e4b68748497fd1b2dda6a2eb02f356c9d68010f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a25b1bbeb9f5c7ffec1fd2c12a8017e2af3f7aa13fc33eceddf0158ba507d97"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  # always pull the latest commit from https://chromium.googlesource.com/chromium/tools/depot_tools.git/+/refs/heads/main
  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "7d1e2bdb9168718566caba63a170a67cdab2356b"
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