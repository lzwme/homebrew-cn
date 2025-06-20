class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.2029.tar.gz"
  sha256 "94ba4bb5cfbb02bd654c7b8ae9381769c7d71128419a4058233fa254d2d6fadc"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2b19812099bcc6b557fb3fac73171529a89d79efe37ae38e93cd4e05ed6801ec"
    sha256 cellar: :any,                 arm64_sonoma:  "961088bf2cdad11f843bade39e32e9c2608caac69a4ed87fe38bc1ddb16092e8"
    sha256 cellar: :any,                 arm64_ventura: "d4efd59e430c4c3f74d4c63e673ae46a74450031cfdde315d857fbce341370bd"
    sha256 cellar: :any,                 ventura:       "765f2de84a302d10a40ccf46527d9bb50e1f695f1e70d8f72ed278d18a9cc379"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dda7a92a927576b541d273cd4c47af7f4396616a7dd4f43c2600acdc18a0db4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9f2d171a5f950734673481da0e5af3511c323f475f0c7570b55f579561ffeac"
  end

  depends_on "dotnet@8"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
    ENV["DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"] = "1"

    dotnet = Formula["dotnet@8"]

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --no-self-contained
      --use-current-runtime
    ]
    if build.stable?
      args += %W[
        p:AssemblyVersion=#{version}
        p:FileVersion=#{version}
        p:InformationalVersion=#{version}
        p:Version=#{version}
      ]
    end

    system "dotnet", "publish", "srcJackett.Server", *args

    (bin"jackett").write_env_script libexec"jackett", "--NoUpdates",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  service do
    run opt_bin"jackett"
    keep_alive true
    working_dir opt_libexec
    log_path var"logjackett.log"
    error_log_path var"logjackett.log"
  end

  test do
    assert_match(^Jackett v#{Regexp.escape(version)}$, shell_output("#{bin}jackett --version 2>&1; true"))

    port = free_port

    pid = fork do
      exec bin"jackett", "-d", testpath, "-p", port.to_s
    end

    begin
      sleep 15
      assert_match "<title>Jackett<title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http:localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end