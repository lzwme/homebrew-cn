class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2066.tar.gz"
  sha256 "abbfc03585adc4584c78a094d9e135981e869a34c97143453d8be074c66376cd"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f6e5d21c5d416e8d310e7b391d2d6ed9e37c7bda595fcf28b9f1eea1dcb5fd91"
    sha256 cellar: :any, arm64_sequoia: "1d3fc7f5ef36a866d66fc0e23b9aa1f19cb92cbecfa72483c3455640dee08269"
    sha256 cellar: :any, arm64_sonoma:  "2359d64a1f7b8351b6d5ffaca556ebe04efe1923b8a9352eb452a4ac59d08941"
    sha256 cellar: :any, sonoma:        "ccd0ed94d30e50da21561e04c144e90acaebd181e0d3c5abac5f9e49105e9372"
    sha256 cellar: :any, arm64_linux:   "290d4f538efebb1b57df73f795e88470db9466fe338f8cf9b5ba5ef84229ce70"
    sha256 cellar: :any, x86_64_linux:  "67c2b978dcb27b51eeaaada06472b07083db593b1cbdeac7b7ad884fee97d066"
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