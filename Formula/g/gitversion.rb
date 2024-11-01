class Gitversion < Formula
  desc "Easy semantic versioning for projects using Git"
  homepage "https:gitversion.net"
  url "https:github.comGitToolsGitVersionarchiverefstags6.0.4.tar.gz"
  sha256 "766dc4f7b79a9caa344f2a32ecaabd559346a6a7d74ce1340735ab7a8a2582d0"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1dda0d82f91e723ea70609c458d83b9b9bb7b3982e8d52b7aea5e1cf35714b38"
    sha256 cellar: :any,                 arm64_sonoma:  "56e13ee7c213f32fe8c3388c6e70c6fb2cbd9a9149585d98cd843da4de8d5d10"
    sha256 cellar: :any,                 arm64_ventura: "b6408b94f75edc80f8952fa1cc3105d42e3cafb9ff8de81ff7909c55358a993f"
    sha256 cellar: :any,                 sonoma:        "0ef11d130e0b4a431279f245fb3972e17480c3c9de34a3a4ca086477577aa68c"
    sha256 cellar: :any,                 ventura:       "3d9efd399a978d43eddc6d66a34946a838171afc16f5da7ded0848fdaa38b018"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0c376d77a35462b2a2f8071b9b766f64e41b3788339fc0dbf64224c3b45f4d3"
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