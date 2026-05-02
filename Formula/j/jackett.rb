class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1807.tar.gz"
  sha256 "9fadeb2d4475c04733326f7118f1812076d36243cbd670c14fc7305a9f5bb7b5"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f9a73b80910d4192471574381f71a44b4177394eb6c62d3f2f532fbcd295f587"
    sha256 cellar: :any,                 arm64_sequoia: "8c7c49e236b38e690fde944322fb7fa95cf9daebb61c4ccc53ebff7d6ec2d6e6"
    sha256 cellar: :any,                 arm64_sonoma:  "e629315c8a63d6ffee9706840904c0f82acc2b945cf5f4e6d49757826b51fc02"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ba46cdc9d71cedac5c026046bdd67020463f5e0ae769488b1383c3af32f51d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfe562366033445069ddaa042d03c81ab6826108ea3730dddceb3a46e885c76c"
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