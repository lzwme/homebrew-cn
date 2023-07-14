class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://ghproxy.com/https://github.com/dart-lang/sdk/archive/refs/tags/3.0.6.tar.gz"
  sha256 "7df8264f03c19ba87453061c93edb6a0420784af130f15b421237d16c725aaf4"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41de80727643e9a79a28e7400b005e142319e17e2b69585c61489f8324854a34"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42e29fdd1fa774749b4be07f0e6681de3209e261905fdd04f7c64832d23d8b22"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b037921c80f518d3e840b5b5cdea67695e6d1739b062190268fe7212fc25414c"
    sha256 cellar: :any_skip_relocation, ventura:        "5518ab80cd9e3b84a1737118b90748684850d00f83acf00cd4ce4841ea474010"
    sha256 cellar: :any_skip_relocation, monterey:       "ad7b9dea60a97937a570532ce15cf44d630ef2df50627493e3e5457137546464"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a5f4173ad78abacd1bcfc4ee4e04de1a5bf3d263b47a30824163c2e3032a40e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfe14fad4939ea34d48ef0b305e8e9244f0766532236d3e7ffd40945c1c78d6e"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "018e46c03d62b67aa881bc44a9346daa2771ca8d"
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