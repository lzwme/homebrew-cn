class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https:dart.dev"
  url "https:github.comdart-langsdkarchiverefstags3.4.4.tar.gz"
  sha256 "2057c67402c38993780d38358fbe1e5ae5cc5b59cf29d579937caac97361716a"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b6f9e7964add461a2db2547fc85275bbfaaabb3f51bfcaac8deb7dffad67fd82"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "65c0e5137fd5dc148e13b17dcd6d106d85c8539f11838f42c65fc648f837f880"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb318d9cb8e5598d2e17a6a65aa023e0a5a70bbd07cf0af76c05c14b15f486b0"
    sha256 cellar: :any_skip_relocation, sonoma:         "b10d6690f2c32df07024ffe58550c0a5e1a5ba4269c0c5966526d6923a6bf905"
    sha256 cellar: :any_skip_relocation, ventura:        "eaa8f9351cc46a3cd5c50b193122ac3806045e59d5f12e67f99f3720e82bff90"
    sha256 cellar: :any_skip_relocation, monterey:       "43e08fca904ee9ee6494b1c3c573a8e865a4c0ba8c088fa2298f9cc05a84d838"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08fd55a21dd30120dcb557d3ac6d97ff3852f2b4bbd2f6ccc38849ccb25a8a82"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  # always pull the latest commit from https:chromium.googlesource.comchromiumtoolsdepot_tools.git+refsheadsmain
  resource "depot-tools" do
    url "https:chromium.googlesource.comchromiumtoolsdepot_tools.git",
        revision: "6daca505974e4efe9df926521daca261f25f1994"
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