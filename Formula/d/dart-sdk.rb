class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https:dart.dev"
  url "https:github.comdart-langsdkarchiverefstags3.5.0.tar.gz"
  sha256 "a2396d8809901cfca05e2fc9c2a3b363115335c4189c956fe7c9c8a56e278c55"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d5a94238e486e08ff694c46a8b66d77d9e5d779822ee441cc38a834f92b488af"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe0b9cd0c6c32f1f692dffe56b07f2a765187a0443223f1b4da1bf687de1c9cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94f6b817c95296a3e898dc3219753186beae4321e716e22cf12be74a58ca0252"
    sha256 cellar: :any_skip_relocation, sonoma:         "1288be9ce492719fa77bce9cc6daa3c0d1d9783fbf645439d9fb5f7345a09f11"
    sha256 cellar: :any_skip_relocation, ventura:        "412886aee49d5d84d6f70bee7afdb30596de677860d43b976b906f270d4a5188"
    sha256 cellar: :any_skip_relocation, monterey:       "975a8e86844091da8898eddd675218e501ce7c5649fb124e2e984a1156933a96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdfc1a9f1d90bb9de1ef52bbaa67572837f3d60e1a26e222127e94c012ae2ebd"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  # always pull the latest commit from https:chromium.googlesource.comchromiumtoolsdepot_tools.git+refsheadsmain
  resource "depot-tools" do
    url "https:chromium.googlesource.comchromiumtoolsdepot_tools.git",
        revision: "4c050c6f1a34c7b1aaf503d97b871afb8540e54f"
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