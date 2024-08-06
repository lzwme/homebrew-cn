class Gitversion < Formula
  desc "Easy semantic versioning for projects using Git"
  homepage "https:gitversion.net"
  url "https:github.comGitToolsGitVersionarchiverefstags6.0.1.tar.gz"
  sha256 "8939f6c7deafb9a7c08219b13d9955165cce79cf9959ce60ae51c66a155d71d4"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5533ce2a187084f933b5609f5877b8459687d0a6c6cfcf66359cb52081d82131"
    sha256 cellar: :any,                 arm64_ventura:  "e8ba459cb561d5fda1ae28d1af04ddce475e64721b113b2330157cb17d12f745"
    sha256 cellar: :any,                 arm64_monterey: "f2605ae56ffc877be7d5838f530916827cb2fd1d027c4388ebbd101afd3dc9a2"
    sha256 cellar: :any,                 sonoma:         "44f41dd4f4334f035a185110daf188a060b0366a6ef1f41f206a096ea24bceb9"
    sha256 cellar: :any,                 ventura:        "47f4413f6ab2c7931438c787aaac84756e2f634f17ec98589411b023faa036c5"
    sha256 cellar: :any,                 monterey:       "3999ba998ec2391bc26e441fefdf6ceaa2b5b75ddc93cf03bf1f50e6f6f59310"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7250849c142bd25f32a6a026a0b1338cc7fb24097b3e74b25647035664e8fca3"
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