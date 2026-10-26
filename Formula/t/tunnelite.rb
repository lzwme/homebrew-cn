class Tunnelite < Formula
  desc "Secure tunneling to local applications"
  homepage "https://tunnelite.com"
  url "https://ghfast.top/https://github.com/cristipufu/tunnelite/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "6c18cddf8b729a105d44bd225b14044a4c61864d0a5419ad5b04b146e9300de6"
  license "MIT"
  head "https://github.com/cristipufu/tunnelite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0c59bf00519d124c862450efe4c023e368aeeb737ca2e81706ddd3d6c2164059"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "30dca36d57a41855a8793b765effc0f570626889379dc66d3ad19ec32fb84445"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "36d96199ebfef1d97c1620e43e31efdf37e19b1c34abaed347428d4e5674458d"
    sha256 cellar: :any,                 arm64_linux:       "94c30db6a9e8caabf40b73458227fc7706178f00e32375b4b80962bc4976ea74"
    sha256 cellar: :any,                 x86_64_linux:      "d8bd7452a5cd2daa8f43ac6ccc8683b81e5a909ad00f8867883dd8535e231d0c"
  end

  depends_on "dotnet"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
    ENV["DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"] = "1"
    # .NET's user-scoped named mutexes need a writable runtime directory on Linux.
    ENV["XDG_RUNTIME_DIR"] = buildpath

    dotnet = Formula["dotnet"]
    # Force a single MSBuild node: worker-node sockets are denied by the macOS sandbox (Homebrew/brew#23920)
    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --no-self-contained
      --use-current-runtime
      -p:PublishSingleFile=true
      -p:Version=#{version}
    ]
    system "dotnet", "publish", "src/Tunnelite.Client/Tunnelite.Client.csproj", *args

    env = { DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}" }
    (bin/"tunnelite").write_env_script libexec/"Tunnelite.Client", env
  end

  test do
    # The sandbox denies FSEvents, so .NET's config file watcher would hang
    ENV["DOTNET_USE_POLLING_FILE_WATCHER"] = "1" if OS.mac?

    assert_match version.to_s, shell_output("#{bin}/tunnelite --version")
    shell_output("#{bin}/tunnelite ftp://localhost:1 2>&1", 1)
  end
end