class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1223.tar.gz"
  sha256 "1c33234a93a4ad78cfc2c78dca3bd2f55ed4435a2f9316ab5509e74edc2db121"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c8ea7064e213c502873fa3e94dfc9288189c0c7bcf2f81c2a7176fcd30a5537c"
    sha256 cellar: :any,                 arm64_sequoia: "73eb2a4cd1d4c4e7371ca7c0c9f847540bdc83b416c26b371deca598347d78d9"
    sha256 cellar: :any,                 arm64_sonoma:  "4a6890da176e00d9fdc0160817c8c3c34f6f1d2cf753cb0e6275d1f4a881966f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13c6c24e2ff9f4fd2030eab58d819d89f70e12f4d9bc421ca323065e12e79a40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a11c75fd41baf6b7e7be3475d36a98d4ad4ba20738af16557f4aa922458c2dd"
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