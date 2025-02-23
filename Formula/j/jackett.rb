class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1450.tar.gz"
  sha256 "9037855572917408eb4e8410b113f0d790cc8dd5ddd077015c618f290370bb72"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e0280af0a32413c7a5d7d9b44ed96af05d7f61c0b6f778608e28461ad4fb76df"
    sha256 cellar: :any,                 arm64_sonoma:  "09c856e787e6a9dec04d9bee16de6b46dc318c482d15742d352696a7f6ecc92b"
    sha256 cellar: :any,                 arm64_ventura: "3d389cd3eb39a26666eb75b02bc9123c8f2c4e860a7efcc3d64c72568255be2a"
    sha256 cellar: :any,                 ventura:       "2cfcd4c31cea1cbc43a10be20d46bb01111460fb52d9f578c449c10ef8672c60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2199416404f563d7387b87b6503ef3998f081a9249a7e5e1783164b393f01767"
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