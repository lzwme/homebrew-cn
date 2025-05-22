class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https:dart.dev"
  url "https:github.comdart-langsdkarchiverefstags3.8.0.tar.gz"
  sha256 "a3106d94904bfc5dcb3bcd0b7e97d8676e0bf0ea94671ff933f53b603bf28045"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "200ce05061f3c15af92d1af006e40d239510a246de4aebab6906013294f54b90"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca35755df53c467390cca02e22e182e9cc5e887f3e4104a61f8aa5e5fb4999ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c9277c23617d3e55c9c996ff8e9fb3b860a6c9172b031f72811157a274eb469f"
    sha256 cellar: :any_skip_relocation, sonoma:        "444bb09ba6c1536be3825c0beed2cd45738aa98a54c2fd6d681b7d069def2945"
    sha256 cellar: :any_skip_relocation, ventura:       "bf7d62fc2374a2e2bdf3ba6032305424c86682437558e0ca4439c05b47ee14f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a61bb0629915c615a609dabd4e72aa64572f500087b7199c07056e341e59b5e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37fc0b24d3613295eff1052b9e8976745044c530ac8a6f65838e2283ae8302a3"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  # always pull the latest commit from https:chromium.googlesource.comchromiumtoolsdepot_tools.git+refsheadsmain
  resource "depot-tools" do
    url "https:chromium.googlesource.comchromiumtoolsdepot_tools.git",
        revision: "0888983e473613d853c419245b97294e46497798"
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
      libexec.install Dir["#{out}Release#{arch.upcase}dart-sdk*"]
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