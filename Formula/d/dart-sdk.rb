class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https:dart.dev"
  url "https:github.comdart-langsdkarchiverefstags3.4.0.tar.gz"
  sha256 "52c895c3f331d29d127f2d5561f0e2d3dc6a8f70ed2680cb529cea4ca50be257"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7fb88ce46df9f970068feeef34235613a923ac425eea6c8ae308cb58ba558de5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "55305b5fb3fac8a8c6e6c729715087b332d730ffc42ea130d00f372e717f44a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14b11c34c19ede4e91888eca7da1c63ff529d34cf94e6ba540184adf6be10bd6"
    sha256 cellar: :any_skip_relocation, sonoma:         "09ec21deee380713d4f8dc66b50577ae3541942a3bfcb2dd9b514a193eeab9de"
    sha256 cellar: :any_skip_relocation, ventura:        "b3c2c4fe87bac0fa4ad457b50d9384bf78e3722cea0f839379ba548062e3661f"
    sha256 cellar: :any_skip_relocation, monterey:       "285e4e87c88d3e385626752f4613240b462a3a0fdae0e631020636f10406098c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "565cf459def6f64e23af9703389186f36aa3298bf3904aaa6aa2c496ecf32b52"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  # always pull the latest commit from https:chromium.googlesource.comchromiumtoolsdepot_tools.git+refsheadsmain
  resource "depot-tools" do
    url "https:chromium.googlesource.comchromiumtoolsdepot_tools.git",
        revision: "28ece72a5d752a5e36e62124979b18530e610f6b"
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