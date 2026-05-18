class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1870.tar.gz"
  sha256 "f2a612c38d07f50a8f6b9e5e707b572051293a3213969a5b8cd2e47fd87606e3"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c9b59c975ec844052bc0cb5c8d0b79998f62ac70c679c99368454c50d54a1134"
    sha256 cellar: :any,                 arm64_sequoia: "76ed178d51e41befecd462dd6338d4fd8ff64479508a017b873fbd7cbd12a7b3"
    sha256 cellar: :any,                 arm64_sonoma:  "46b69972e9a40f050e8e6338aadfb8c345cb47398944aaef2d364c1f4afaf237"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e1aff3325bdac9c4b619cd0c701f4472db14ce65fe021bc754d6e92d8a7f1e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6029784ff938dcd7d42f00120f1d71ce48b2650596e28c42be7e693459634a32"
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