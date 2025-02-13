class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1411.tar.gz"
  sha256 "77d7912835de603708188ffa1fcb9006f1304efc50c286dd0c5d0ac1ffe80184"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2225e0d6f32314ad4a7a2d51d763b5d5c0b7054211fdac518ef092e48781d898"
    sha256 cellar: :any,                 arm64_sonoma:  "a806f79e25399e9546b3627ae5408393be62ad62625434fb6fd6a9e0305fde52"
    sha256 cellar: :any,                 arm64_ventura: "28edc8d2ac56f63061a4691e5e838d1231a8f00e6e1d9146990de4eff08385ce"
    sha256 cellar: :any,                 ventura:       "2ebef91e8bf74c0d1f333a57aded0117072e1252600f6fa00a05ed3964d38225"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34a8ae53b2117ff6c7815773008ceb7598477c034ffa3fd9109c9d242662aae1"
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