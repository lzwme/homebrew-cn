class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1103.tar.gz"
  sha256 "53a1ac1fefcd4655ef31e794b190123ceee0545bacd3c4ffe651e94906e84680"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "eede3ba806b568affb015ebf686573e3a551e9d5490a3f50746fc5396427edc7"
    sha256 cellar: :any,                 arm64_sequoia: "5bdf97a1a1347b32bf6591870ab13aefdd079ca4e67f4117a5868a1055afa429"
    sha256 cellar: :any,                 arm64_sonoma:  "0f282eb53b47eeed3d5c01a1586d0d77e1af6ab0c6838c8419992d08d759e9f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4be0e7948834bfa1c271c14ef701cd177394209703f3bd9be96adcd8acdec5b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "193217025bc141e2e855a32657083ec3a52533ebcf91000f5fd0094a09ef95c6"
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