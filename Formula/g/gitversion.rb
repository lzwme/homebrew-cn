class Gitversion < Formula
  desc "Easy semantic versioning for projects using Git"
  homepage "https:gitversion.net"
  url "https:github.comGitToolsGitVersionarchiverefstags6.0.5.tar.gz"
  sha256 "621b46427db8947fa9a2ff04d0fcc4d00d0dd0ce05e248eb8d7bbc18e4ba29a7"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fae232c086ea1d8c37f1b3984ad05064278e79adc156825985aa6fe8c2523a2d"
    sha256 cellar: :any,                 arm64_sonoma:  "aa322c23f444e8dff137177a50559760c9d4f062bc5fc1b8610f67f5149b9842"
    sha256 cellar: :any,                 arm64_ventura: "8b49968692aef48626c8dd70abf01204cd9246577ffc12b6e9e766234fac3464"
    sha256 cellar: :any,                 ventura:       "bf1f9c7685da72147892bb11d1ac14e4167ffe2edb9abe9a41fa77cb1eeb9665"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc5389bd40a2e8e7ca02acb9704b5ec0d69b51421939baee10b53e48a1f6be7f"
  end

  depends_on "dotnet@8"

  def install
    dotnet = Formula["dotnet@8"]
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