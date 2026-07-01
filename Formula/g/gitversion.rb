class Gitversion < Formula
  desc "Easy semantic versioning for projects using Git"
  homepage "https://gitversion.net/docs/"
  url "https://ghfast.top/https://github.com/GitTools/GitVersion/archive/refs/tags/6.8.0.tar.gz"
  sha256 "7343681d28ca823d119452ed3883e8501feca1a878a9e817d4c013cbb523c525"
  license "MIT"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1556857a0e5d7c4fba530541a6a7d21aacc1f12ba2bc0b0f5c01fd8cbff54d4d"
    sha256 cellar: :any, arm64_sequoia: "1fdb699bd5f7c2e528e953a39cfb1f7f9bcf2cbcb37b26fb937866d598e8ec7a"
    sha256 cellar: :any, arm64_sonoma:  "a8582cc3335ad089c6dea6628d0e26f8069d741ee6faaa3b796e10e830070615"
    sha256 cellar: :any, sonoma:        "047dd3c43b6fe136bf9bc6dd3e5b01a5cd08e89b35662926ce6dd1649db44e33"
    sha256 cellar: :any, arm64_linux:   "d74d2a30b2cf7c06899237b3c529986e6cbbde49e4c68d69940b830e43d0e169"
    sha256 cellar: :any, x86_64_linux:  "6449124671454703b6df159d87adff022a298b884dbc225e2e11f20e25e5638c"
  end

  depends_on "dotnet"
  depends_on "openssl@3"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
    ENV["DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"] = "1"

    dotnet = Formula["dotnet"]

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --no-self-contained
      --use-current-runtime
      -p:PublishSingleFile=true
      -p:Version=#{version}
    ]

    # GitVersion uses a global.json file to pin the latest SDK version, which may not be available
    File.rename("global.json", "global.json.ignored")
    system "dotnet", "publish", "src/GitVersion.App/GitVersion.App.csproj", *args
    env = { DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}" }
    # Ensure OpenSSL is available for cryptography operations on Linux
    env["LD_LIBRARY_PATH"] = "#{formula_opt_lib("openssl")}:$LD_LIBRARY_PATH" if OS.linux?
    (bin/"gitversion").write_env_script libexec/"gitversion", env
  end

  test do
    # Circumvent GitVersion's build server detection scheme:
    ENV["GITHUB_ACTIONS"] = nil

    (testpath/"test.txt").write("test")
    system "git", "init"
    system "git", "config", "user.name", "Test"
    system "git", "config", "user.email", "test@example.com"
    system "git", "add", "test.txt"
    system "git", "commit", "-q", "--message='Test'"
    assert_match '"FullSemVer": "0.0.1-1"', shell_output("#{bin}/gitversion -output json")
  end
end