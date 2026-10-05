class Gitversion < Formula
  desc "Easy semantic versioning for projects using Git"
  homepage "https://gitversion.net/docs/"
  url "https://ghfast.top/https://github.com/GitTools/GitVersion/archive/refs/tags/6.8.2.tar.gz"
  sha256 "02b7efc0b9cfee26971c0f89b27724eb51d33c3230788963e77dc94070173c21"
  license "MIT"

  no_autobump! because: :bumped_by_upstream

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "27eb919eded79ab5813b14491887641e3d98383c83a0eafd74be46f4cac31e59"
    sha256 cellar: :any, arm64_tahoe:       "7f514ea7bd2159c84e06d03daba4e900aafa36df3569a54fc69399a377b63882"
    sha256 cellar: :any, arm64_sequoia:     "fb0f4e2c648885d6fee65dce3f09942f2e7b00591f0ae2c02b9654de23d71396"
    sha256 cellar: :any, arm64_linux:       "4f48cf0bc6bf56c1aa2375e0ef93a4fd6ef68cb6676b53b89053dd151cedfe57"
    sha256 cellar: :any, x86_64_linux:      "773910581edef4075a4f6108f3e9216debaa0a41072040de5e7d0f034336c14c"
  end

  depends_on "dotnet"
  depends_on "openssl@3"

  deny_network_access!

  def fetch
    # GitVersion uses a global.json file to pin the latest SDK version, which may not be available
    File.rename("global.json", "global.json.ignored")

    system "dotnet", "restore", "src/GitVersion.App/GitVersion.App.csproj", "--use-current-runtime"
  end

  def install
    ENV["DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"] = "1"

    dotnet = Formula["dotnet"]
    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --no-restore
      --no-self-contained
      --use-current-runtime
      -p:PublishSingleFile=true
      -p:Version=#{version}
    ]

    system "dotnet", "publish", "src/GitVersion.App/GitVersion.App.csproj", *args
    env = { DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}" }
    # Ensure OpenSSL is available for cryptography operations on Linux
    openssl = deps.find { |dep| dep.name.start_with?("openssl@") }
    env["LD_LIBRARY_PATH"] = "#{formula_opt_lib(openssl.name)}:${LD_LIBRARY_PATH}" if OS.linux?
    (bin/"gitversion").write_env_script libexec/"gitversion", env
  end

  test do
    # The sandbox denies FSEvents, so .NET's config file watcher would hang
    ENV["DOTNET_USE_POLLING_FILE_WATCHER"] = "1" if OS.mac?

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