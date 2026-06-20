class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2080.tar.gz"
  sha256 "0f3525b28eca56287be7a54e959d4dcd3b29125724acf4a326bfbc25706a0155"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3562aa7822e2ca300b345eba98106d7bba3dfb25216c6556f427b9658d410ecf"
    sha256 cellar: :any, arm64_sequoia: "da0e90dd69c983f8868cc25817a703a2c8a106c3fea39f66bea333848713220f"
    sha256 cellar: :any, arm64_sonoma:  "429f9395ab1aa3ae228c084236a1d0936f448b24d3a36a104cc64349b7d7ece4"
    sha256 cellar: :any, sonoma:        "2a75412ad087b81050d9bd46a4e47786763fda9f1f93addac58a239a276458c7"
    sha256 cellar: :any, arm64_linux:   "8d56ebfb7207cdc18e0391eb2bd88b03f7de94f8c84dc24b2313425971ed5229"
    sha256 cellar: :any, x86_64_linux:  "1d3dec9a75a121fea5ed54df08f5c8ae0708f72084070aeec0aa6e1646698c85"
  end

  # Aligned to .NET dependency. Can remove if updated to latest .NET
  deprecate! date: "2026-11-10", because: "needs end-of-life .NET 9"
  disable! date: "2027-11-10", because: "needs end-of-life .NET 9"

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