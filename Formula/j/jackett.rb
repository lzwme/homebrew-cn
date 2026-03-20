class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1412.tar.gz"
  sha256 "d293c40620a82b4c8c634ac176c8d22e2a75926d92562de5d949290419273223"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "15520ec5712ba9f38d9242aa5f0d692221018d1ba9ead110539ee699fda50a8d"
    sha256 cellar: :any,                 arm64_sequoia: "5399b76c9386179ac7cd123c90aba6c02d09d4d6a7ea71ea9967e6d708a2009d"
    sha256 cellar: :any,                 arm64_sonoma:  "7b783def44c7cc9f67395ca651ed6cd2ed95684ca3325d99f1a668f1b01af3d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32dcd6d4c95bbdb8c646fbb11322d76eb30a723e9634359c7c23c4d54bbc0193"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46f0ab55219be6f278bc4314074a9869b474a4b331f62a1477a199477d889fa7"
  end

  depends_on "dotnet@9"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
    ENV["DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"] = "1"

    dotnet = Formula["dotnet@9"]

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --no-self-contained
      --use-current-runtime
    ]
    if build.stable?
      args += %W[
        /p:AssemblyVersion=#{version}
        /p:FileVersion=#{version}
        /p:InformationalVersion=#{version}
        /p:Version=#{version}
      ]
    end

    system "dotnet", "publish", "src/Jackett.Server", *args

    (bin/"jackett").write_env_script libexec/"jackett", "--NoUpdates",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  service do
    run opt_bin/"jackett"
    keep_alive true
    working_dir opt_libexec
    log_path var/"log/jackett.log"
    error_log_path var/"log/jackett.log"
  end

  test do
    assert_match(/^Jackett v#{Regexp.escape(version)}$/, shell_output("#{bin}/jackett --version 2>&1; true"))

    port = free_port

    pid = spawn bin/"jackett", "-d", testpath, "-p", port.to_s

    begin
      sleep 15
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end