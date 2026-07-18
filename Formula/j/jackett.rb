class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2228.tar.gz"
  sha256 "dd568d3999a9ce9820e0f1e8590f8a7929e8ee9a10011ffb254ba342ba65511a"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9e720473b0abb63d8f6a75228175f0545300d639b896725fa20463b3e409769a"
    sha256 cellar: :any, arm64_sequoia: "79d7008c6384f6b84c81389f5e236a324e84927b233ae4c4657fd751c11b96af"
    sha256 cellar: :any, arm64_sonoma:  "26397087bfe93bd1cb5827f5ca787aca2f7f36efa4a6e6033164565f703af430"
    sha256 cellar: :any, sonoma:        "53ddd65cb4f341736035ae234d89fd5488cdccaed7b50e128086305c56f56b9d"
    sha256 cellar: :any, arm64_linux:   "410d8cc64ab5f4d2b85660ca1c5c9d2ad56b67637e892cfef9f7c5ea2f61be7b"
    sha256 cellar: :any, x86_64_linux:  "13b73ecd80d83d5d53303f9ae48cb30a25edba03855d9e1b94f10ab1c5101797"
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