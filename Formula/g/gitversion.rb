class Gitversion < Formula
  desc "Easy semantic versioning for projects using Git"
  homepage "https:gitversion.net"
  url "https:github.comGitToolsGitVersionarchiverefstags6.0.0.tar.gz"
  sha256 "b0de243cbf3a59a1415efce35aec8531caef17dd05562d18e9777f98a4a4b973"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "40c413fb8178335e100db2961d37edd1869e5b405ea01d25fc6e0cee3c7ee0e3"
    sha256 cellar: :any,                 arm64_ventura:  "1626b82250004a371b336a29fe37ac5cd689e1db889ba43d1cb6dbbb65fd0271"
    sha256 cellar: :any,                 arm64_monterey: "08fd171e3e5bc122dc3366ffc16c25892a77c882ee1ca2ed818d6f9321c36698"
    sha256 cellar: :any,                 sonoma:         "95d355db1c6f04f67c121e93cfba36b98bd9ba433b484f730cdbe58f376b1ab6"
    sha256 cellar: :any,                 ventura:        "c79a9de564e35d31aa469a61d8ebb72135c9d18a621132a066b0ac1b0b381956"
    sha256 cellar: :any,                 monterey:       "3c565d656be2953995934e51ed0ee3a4cc08d16fba65835a1367b49c469a7f71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3afc85979da0857e1f39bd86910f546a5a7e631f1bc001f03bbacab39f25c540"
  end

  depends_on "dotnet"

  def install
    dotnet = Formula["dotnet"]
    os = OS.mac? ? "osx" : OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --runtime #{os}-#{arch}
      --no-self-contained
      -p:PublishSingleFile=true
      -p:Version=#{version}
    ]

    # GitVersion uses a global.json file to pin the latest SDK version, which may not be available
    File.rename("global.json", "global.json.ignored")
    system "dotnet", "publish", "srcGitVersion.AppGitVersion.App.csproj", *args
    env = { DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}" }
    (bin"gitversion").write_env_script libexec"gitversion", env
  end

  test do
    # Circumvent GitVersion's build server detection scheme:
    ENV["GITHUB_ACTIONS"] = nil

    (testpath"test.txt").write("test")
    system "git", "init"
    system "git", "config", "user.name", "Test"
    system "git", "config", "user.email", "test@example.com"
    system "git", "add", "test.txt"
    system "git", "commit", "-q", "--message='Test'"
    assert_match '"FullSemVer": "0.0.1-1"', shell_output("#{bin}gitversion -output json")
  end
end