class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2353.tar.gz"
  sha256 "3c5b62ca376afb904a9dc2f8e533a0afa20fe6dd94fdd0488fa39b935d9f9270"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2c8548226bba17096ff5ebf07414012add267fa91591a8f3986d2231d6dc7506"
    sha256 cellar: :any,                 arm64_sonoma:  "d3bc6b80ed728c7b83e79beff5fc143b33ec7e511dd3ebb06d2992063fb6fe79"
    sha256 cellar: :any,                 arm64_ventura: "9eccbbc9082321507e2b1a8db9c953067370cb9c697153cb173d067409072735"
    sha256 cellar: :any,                 ventura:       "4a489d3dbf7615539cea79ec2a8ea507038cdab872a5d98a371dcdecf77b7e1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dafae258b5822673873498159940bdde3738556330fbfa615d542289f7685992"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15a8e1dfd588724d8be01b0119f92a3824f9d626f8d4b0f78262cb748b0b7023"
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