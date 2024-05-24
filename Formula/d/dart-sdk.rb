class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https:dart.dev"
  url "https:github.comdart-langsdkarchiverefstags3.4.1.tar.gz"
  sha256 "4e1177bc635c8056f28541fc4a6f33243074a7f731be36c912ed2798df2b8a55"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "da85c2aa4808cc117c3b8c70a6b61789335e23d82616d1ab343b33688516415f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa84ee24741dc848cf701257d3290153059ae6c1297684982bf7738f1a5b7fd6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f7429db35b9e8789e912c19b91e01135cba62c47816ef9c7010fab31d281367"
    sha256 cellar: :any_skip_relocation, sonoma:         "0f60cd2f5e7161507ff16629aaa93d2aaecfb9f46aedebd5f52461292ac053ab"
    sha256 cellar: :any_skip_relocation, ventura:        "ed29c181016ecea7d064388987f7a305d84a5dc884c255725b6f1479f8338723"
    sha256 cellar: :any_skip_relocation, monterey:       "1cbb85a5a88282f15546cb0bec9f700c9f49316cd7aa35bc8a50632e44cf6dc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ed8e644d332d58be7f0a97801ef00cc12151491541836b5592868583e67f911"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  # always pull the latest commit from https:chromium.googlesource.comchromiumtoolsdepot_tools.git+refsheadsmain
  resource "depot-tools" do
    url "https:chromium.googlesource.comchromiumtoolsdepot_tools.git",
        revision: "525b18d46bcb3117032014bd17773235b0c8a352"
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