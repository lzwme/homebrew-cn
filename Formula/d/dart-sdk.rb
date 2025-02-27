class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https:dart.dev"
  url "https:github.comdart-langsdkarchiverefstags3.7.1.tar.gz"
  sha256 "ec8cc8ddc145f55129777c911c83b826c663e8a735dd59df9b2b152f94b18ceb"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf555e59da47aa3c5813364791028a48c1182bfc5d6469e6242232a6fdfc2f6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8eb1459c187853ee27800e7e5a262ee32f55fbfed77160781362b1d00239fc7a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "31cc8af74a94cdf4cd243046bb9a77759268cd5d59c915a256a41df0053e393d"
    sha256 cellar: :any_skip_relocation, sonoma:        "af9bd9a9d7243e92e82f5f10ff98093fb8918b2105d3250cb11b0c8008806f76"
    sha256 cellar: :any_skip_relocation, ventura:       "11a180a311220e7d1fcb3260ddeea29e8733d33cd62e4e8adbf3d1773f76c3a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3a50d9db1b8b12b092f695fd8370819f68c66de91f873dbb66f57c6b4fadbbf"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  # always pull the latest commit from https:chromium.googlesource.comchromiumtoolsdepot_tools.git+refsheadsmain
  resource "depot-tools" do
    url "https:chromium.googlesource.comchromiumtoolsdepot_tools.git",
        revision: "678f73bd0e221ed8492033d88b4205707ebbc844"
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