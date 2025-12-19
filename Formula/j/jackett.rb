class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.478.tar.gz"
  sha256 "03018fc2baef57e6d3f7aea92cb7360275265709a2bccaaaae757cdc5ae30663"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dc7eb61530706c245303b4f7372abc16e618d7ccf5befcb30760ec7f1e2dfa73"
    sha256 cellar: :any,                 arm64_sequoia: "fe207e76c34d86a289168eec5899ef14f999796da62192ad28de94a861b4639e"
    sha256 cellar: :any,                 arm64_sonoma:  "d57494cdd46dc97d6010b084a2f937199425fa335a5125d64adc98633e44c727"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a388224edf5dd4f041007fe7c0ca19e1b74172474e3a66503ff7385d9b5f6b52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "619227d5f98a9344a98d493cb7d153b9a0277617546b8c413e9bfa64c68d845f"
  end

  depends_on "dotnet"

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

    pid = fork do
      exec bin/"jackett", "-d", testpath, "-p", port.to_s
    end

    begin
      sleep 15
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end