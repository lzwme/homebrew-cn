class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2007.tar.gz"
  sha256 "0141925c53aff4e1b4644adfa975002ef123e412feb204adab650b156f24c848"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "300b2b5852b9c584a02c791d04c0174e343eaca11eb4cc55d19c17aace595ee2"
    sha256 cellar: :any, arm64_sequoia: "ca98f79f115e47b2e86be5b09133a82df745814dd2f6efee7c32b9906437a8d5"
    sha256 cellar: :any, arm64_sonoma:  "be80310c8dadf07b53df7fff68601dca37e07d0b73ff6369273966a64b628857"
    sha256 cellar: :any, sonoma:        "2d17d5d4974057ff023c20a665fee59c4ef4de54e24ccc95fefd148ea613b447"
    sha256 cellar: :any, arm64_linux:   "ada833648908b19a65cd2efe43f1af32c5ca29978103b50234ee5fa20501145e"
    sha256 cellar: :any, x86_64_linux:  "11f17cbd2005c1007463e3cf2a4020e8433e1a438b5b91cff2552c96af255d51"
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