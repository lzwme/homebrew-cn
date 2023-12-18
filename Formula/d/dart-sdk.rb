class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https:dart.dev"
  url "https:github.comdart-langsdkarchiverefstags3.1.5.tar.gz"
  sha256 "099c560da26a81788c64f066c54be59b7988491f74f227d1641976aa58bd9a34"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1c5453689054cca4736923ad5681f6d5d6fff2a009d604d681b836bda967d8d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2aa80bf777ede735f13537cca493e2a73e9f49b23a0aa57b3493171c725fd3b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf2488f8bdc8876d151a139808102155b2d6617cca015f6effe77d9b15bde5c6"
    sha256 cellar: :any_skip_relocation, sonoma:         "4ab3f9be4644de929c9648ffa4f3ea0e6dcd68ce7874f4f3f780407a95f531b2"
    sha256 cellar: :any_skip_relocation, ventura:        "d7feb3d20a5198060b8d794b19c50aff6c9c24800f392de8ddbe0424a29b4735"
    sha256 cellar: :any_skip_relocation, monterey:       "f949cfe0efac26dbacc34ee3b6b08f3b4cda426b43b9aef39a014a96b9c2c2a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f41ac79ccbd00626aa395b3cfd0dc4e481a713e909dff36a4375a800cd689439"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  resource "depot-tools" do
    url "https:chromium.googlesource.comchromiumtoolsdepot_tools.git",
        revision: "27ea34f94ea114fec4fc4a10720492dbe8f3d738"
  end

  def install
    resource("depot-tools").stage(buildpath"depot-tools")

    ENV["DEPOT_TOOLS_UPDATE"] = "0"
    ENV.append_path "PATH", "#{buildpath}depot-tools"

    system "gclient", "config", "--name", "sdk", "https:dart.googlesource.comsdk.git@#{version}"
    system "gclient", "sync", "--no-history"

    chdir "sdk" do
      arch = Hardware::CPU.arm? ? "arm64" : "x64"
      system ".toolsbuild.py", "--no-goma", "--mode=release", "--arch=#{arch}", "create_sdk"
      out = OS.linux? ? "out" : "xcodebuild"
      libexec.install Dir["#{out}Release#{arch.capitalize}dart-sdk*"]
    end
    bin.install_symlink libexec"bindart"
  end

  test do
    system bin"dart", "create", "dart-test"
    chdir "dart-test" do
      assert_match "Hello world: 42!", shell_output(bin"dart run")
    end
  end
end