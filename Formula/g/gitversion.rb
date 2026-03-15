class Gitversion < Formula
  desc "Easy semantic versioning for projects using Git"
  homepage "https://gitversion.net/docs/"
  url "https://ghfast.top/https://github.com/GitTools/GitVersion/archive/refs/tags/6.6.1.tar.gz"
  sha256 "39430860cf935f531199fab1eae449fd1c870d5446cffbe25db94b4b505b2403"
  license "MIT"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4bad51218b15bd81bd9113a4fa5e1a82df4617468b4be16f1d3732b6d7bd32dd"
    sha256 cellar: :any,                 arm64_sequoia: "9c4f00e525dec3e508b869418d4686789501c12cb4264da6a5addcfc9b2db5e5"
    sha256 cellar: :any,                 arm64_sonoma:  "59164f28e208db3ffd5b8d6b02406c0d3506ebc82eb1924570be867139215e69"
    sha256 cellar: :any,                 sonoma:        "e0c89f137a5ca7eadb969f85bbb0529be13e30ac718d7f18cbfa161a22110dfe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6433107e2b268617d30d0c3ac97b9d4fe1f25ca1ef3e366fd4413596bd8488f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf82fc009e7b1b15e65f02f65472514d7b965e75302c59d8d1f054d3d272f712"
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
    env["LD_LIBRARY_PATH"] = "#{Formula["openssl"].opt_lib}:$LD_LIBRARY_PATH" if OS.linux?
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