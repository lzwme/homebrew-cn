class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2451.tar.gz"
  sha256 "297a21bac1325c4eb435d30156101205bddffac49feeaaec076e84d1e28037dd"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a3a4b9875576bdc0cb9446a81f79b0b49a0af6123bfe9449a7a087f897c59c89"
    sha256 cellar: :any, arm64_sequoia: "b8e4d337ccabbb49a51180c219cac8994b89895b4a8e6639d7e275c82ebd27d7"
    sha256 cellar: :any, arm64_sonoma:  "85bee7ada5841354fed8152784cb516dc022cdc3bc7e48fbb345598ea29a7b49"
    sha256 cellar: :any, sonoma:        "fff8d3826b5682483ac1cbc1d4b02f2af41f21c976c6db2c5b72a515927d1abd"
    sha256 cellar: :any, arm64_linux:   "b76cf200f7dd0966471241f0ff20568303569bbeb2a5002dd06fc6e33101947c"
    sha256 cellar: :any, x86_64_linux:  "5216ac17e1fc1fd927673f4a8fb8ab7ab2f9ca8af98d4f908bafe6194a2830c7"
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