class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https:dart.dev"
  url "https:github.comdart-langsdkarchiverefstags3.7.0.tar.gz"
  sha256 "274b66d7aaafc8f1a1e9252551fd9efbf4902b6a8ad791d0145e601712bcc129"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20b6744036913ec6dd820abedb0b4a755b419914e06c9d1495dc87d9a0016565"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f7ed886d606032a301e9786061030aaac3485e7d451f6ab96ba6d251e3967ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "751a71a1b0d59cd15c552ab56a5a0bd1fc39a3389a059995eb047a9287892665"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2113a0748dcc215b54a1da889f6fded9c26e55fcaafd8aba9acb80e6032178b"
    sha256 cellar: :any_skip_relocation, ventura:       "4d1d69a88392b78ddb4897ff948b96d0597fa3b15b4924fd09ad1170cda189bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31518f94214661f811288849d8db5d8749e54377bf2385c02a5cb81c8fd066e7"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  # always pull the latest commit from https:chromium.googlesource.comchromiumtoolsdepot_tools.git+refsheadsmain
  resource "depot-tools" do
    url "https:chromium.googlesource.comchromiumtoolsdepot_tools.git",
        revision: "a155deff4221b4d125858076fb5115b1dbd530c6"
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