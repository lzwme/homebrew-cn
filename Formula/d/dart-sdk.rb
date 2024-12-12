class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https:dart.dev"
  url "https:github.comdart-langsdkarchiverefstags3.6.0.tar.gz"
  sha256 "eb88b52ae93cdd7113f527fbfc854149a09d9dbf60930b72e8c5e2c384db5b61"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0dfa2a2344b8bdd35fe7f1d7501857bd0573d766ae75a79c0da9c35a7db0b1f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d354cc1a91f76b0b4cd45a5fe199fe469257324dd9ac1b7b6c156e9c55bf6fc2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a77f9b599f42898cab3fb953ee0e24f58faa7aa121cf34a812911161c6bbd5f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4ca1fb0ec5b5b127dfef23895ab3438309df6f300349bf6e866498fed9bf0d7"
    sha256 cellar: :any_skip_relocation, ventura:       "413e12bec5d9c27e18c40f9f9ad6fa3450e5bb1146724d1cf47773306c83ef98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c16b97d89ce9ece83db12ddbc13a8f60dba605e3ce79917b592f8d6d1ae8eac"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  # always pull the latest commit from https:chromium.googlesource.comchromiumtoolsdepot_tools.git+refsheadsmain
  resource "depot-tools" do
    url "https:chromium.googlesource.comchromiumtoolsdepot_tools.git",
        revision: "a7b6e2238a0dcd29789e93a0a85032f0596ce1c8"
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