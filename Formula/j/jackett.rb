class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2040.tar.gz"
  sha256 "5ea9ce5b47be1f72dd2f07ae03fa9c5f1c763049817aa611e2b312da20381134"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "46426284765f59944f6ecf7d3756717ef8a84bb8ea9650253929d86cc9e55a29"
    sha256 cellar: :any, arm64_sequoia: "8339a39e6c9160f3b5a06ff459fa0d10bb9e487ed63515ca7500d7dd832bd1a5"
    sha256 cellar: :any, arm64_sonoma:  "ed8a2adb14c44afb27bb5068992aee0be7a27b8193903c6f9301576ea0ac87bb"
    sha256 cellar: :any, sonoma:        "39b47bef5c8a41514342436304207b18a55df7a849c88121afd42a9ce3ea8ddf"
    sha256 cellar: :any, arm64_linux:   "87dfd215817ee0ba04d058b961e47b50bf92cb8d7845e5b53791d6c4acf03507"
    sha256 cellar: :any, x86_64_linux:  "ae82b3836c3cc949b3345cdc9db76a7e8fc127038ecd85b8d76a41ac5234a027"
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