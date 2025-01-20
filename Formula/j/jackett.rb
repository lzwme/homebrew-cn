class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1286.tar.gz"
  sha256 "9a13b20d45d28a0bab375fbf01618efa4758617059428e6d045bf8e33d0a3b66"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b59e14a5b226adceb4e7afaa0fa8d3228ed5209df996e5d06127e4f734df6364"
    sha256 cellar: :any,                 arm64_sonoma:  "19bfdcb8c0ec9850d9840528302adb1c5b1f7308df56724075e2a6b455f8423a"
    sha256 cellar: :any,                 arm64_ventura: "88a4ba00fe34b26ac0fd23e54b71a0ccacbc6dbf4510c263b24429af67787f77"
    sha256 cellar: :any,                 ventura:       "15996f47555a80894f7931f79bf1a40447fce8756d80801dcccc230b05fc3e6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00d5e6a01023ee4535c802f279a6cb268c47992b8c903fc099a677beab7ade8a"
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