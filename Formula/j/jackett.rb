class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1874.tar.gz"
  sha256 "8e0874b6dad878541bc175e9265532675da250ea521bce156d6d50a40f980f28"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b8584ed18dbcb34d8d799511b16554ea757fe6d36dc250f060d43b216a82ade2"
    sha256 cellar: :any,                 arm64_sonoma:  "be0efb9cad0e205e34718f4b00bd142d3a2d3ad8692e83fc80a9e7518b85d1e4"
    sha256 cellar: :any,                 arm64_ventura: "df1995e184ff7c1764a9d45cfcdc9ef6fc6346618f19a2595191132ff18b2506"
    sha256 cellar: :any,                 ventura:       "98f25407101853d6dae48321f1d01020b4e44eb0fe2fb1f84773c77710123bbc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "256a09d72684fac4676f8f30a2fe21915fe3716d0482603118555e7ff9ed88aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d441c4dedb5044e61d764b2680ebf68d7d7d8a3e356f3ffd08512753134275b7"
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