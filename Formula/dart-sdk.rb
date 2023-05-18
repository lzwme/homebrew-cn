class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://ghproxy.com/https://github.com/dart-lang/sdk/archive/refs/tags/3.0.1.tar.gz"
  sha256 "d3fce599350592efdf8ddd72cd178e6ee87699c7704fbbc8853e372fe6d16312"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0175d42652839c4fb348c3f34ec4e48918d05adbc16bc5c3dee2ef301df2a6c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6ac39d17016f57bfd2ce5edd7e6e933cad66da6e56d8546d3111a7d5ced9e6d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "76bfba6f60e929953a7ac77365041b3dbb7ee72076afc15e4557e906a5962379"
    sha256 cellar: :any_skip_relocation, ventura:        "d86a291dd79545ffd330fd2d53ab8f81e6449f259685e118b1043a629e85274e"
    sha256 cellar: :any_skip_relocation, monterey:       "c16e52ddfcf5dc56896a2ba5ae67950b5f556f8c30601fc25da124d55be873c8"
    sha256 cellar: :any_skip_relocation, big_sur:        "7cfacb6ac359dc2c6630af1b1b7ae8921e1ed4c26615b81258cce0782f126f86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5597a3790267dd901fd4506cf6e06a9763a23ad73d948e7dbb020c391473166"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "cdefe67b38c4ae7210fe2829fb8f5a1ad7f3e95d"
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