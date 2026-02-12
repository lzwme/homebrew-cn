class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1094.tar.gz"
  sha256 "ff1b9b33c3566c37014a5e5c3db1b972c0e32c256da3895c5094a0b5dc0e743e"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d8bbd242c8b5bc4ca2fb23a3202a700c73694049e271a3e18bba7f4ef269dd29"
    sha256 cellar: :any,                 arm64_sequoia: "516897c87d8d7f0b619adafff2ce2279fc57b7cb2056834b3b2ad81ecb161571"
    sha256 cellar: :any,                 arm64_sonoma:  "65186c0d12404f47dfd1105db6081551165e74d35f6af9d84d7ddeb6a9c816eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd9ccf438213f825673f879afa48487bf5c100415bbb67728b7d9702d06a9ccb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08b4bde8de7ed0397b1cc8a6e3fd4a367ac789abe623e2f281c6584131f19151"
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