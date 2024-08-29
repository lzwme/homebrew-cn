class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https:dart.dev"
  url "https:github.comdart-langsdkarchiverefstags3.5.2.tar.gz"
  sha256 "d8733d695f0d72132b95cb24cf9e6e05b7630ba0b4acae5811b6b2696aeaa831"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f339a1f580efd55e84e1d996b148b1499f38a3d49b30cc3461a6570bf691ebd3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c3a11f5f8eaea9773aea5a4daa70d4934d72c485929430ba74929af3bb6b8f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "792dc2c00092a1562d75fbd76e57688b490c52781f07fe6bac8502f8555be31e"
    sha256 cellar: :any_skip_relocation, sonoma:         "50487539baf01a9b4faadde935b5a4606abae761cd5aedf3761200d5cc336851"
    sha256 cellar: :any_skip_relocation, ventura:        "68b6a85719c2f5b60d90a21b0f324b6a554c9122eb5ad27d2df7457d085f0c9c"
    sha256 cellar: :any_skip_relocation, monterey:       "5aaa37b01b07e28e5aee4704bf666b5fcd27eb03974045e40590135859641efd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "417d28d6b166b96bacf48ec8803741abddf88cf72f0b6f1135c914e3e8f22a75"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  # always pull the latest commit from https:chromium.googlesource.comchromiumtoolsdepot_tools.git+refsheadsmain
  resource "depot-tools" do
    url "https:chromium.googlesource.comchromiumtoolsdepot_tools.git",
        revision: "1f6ef165b726ed7316b8e88666390e90a82e8e50"
  end

  def install
    resource("depot-tools").stage(buildpath"depot-tools")

    ENV["DEPOT_TOOLS_UPDATE"] = "0"
    ENV.append_path "PATH", "#{buildpath}depot-tools"

    system "gclient", "config", "--name", "sdk", "https:dart.googlesource.comsdk.git@#{version}"
    system "gclient", "sync", "--no-history"

    chdir "sdk" do
      arch = Hardware::CPU.arm? ? "arm64" : "x64"
      system ".toolsbuild.py", "--mode=release", "--arch=#{arch}", "create_sdk"
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