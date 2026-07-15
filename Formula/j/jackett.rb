class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2216.tar.gz"
  sha256 "55bf4327eb29d4dc4ab77c408a246de1da3577b9a5545bc6245e733abe26d06e"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c9aecd612d5d47d4b16ccb7697e766c782784a743387065de331923f7d084583"
    sha256 cellar: :any, arm64_sequoia: "12013b17ca1a17a0ea31401002c6acac39ae4a814728022d37e106f9c5f61c6e"
    sha256 cellar: :any, arm64_sonoma:  "31a6409dbdf59928ceb13306b6742ea587b01f177b699c937bf179a572dd22e7"
    sha256 cellar: :any, sonoma:        "311bbb4cd5c2aeb8c23d7a1ad72df1f77d320686d59c2959a788f3c125bdbe02"
    sha256 cellar: :any, arm64_linux:   "0eb14aa4f043991abaebabd1a42645ec8d121a3784621eca59ca5cec71d67fb2"
    sha256 cellar: :any, x86_64_linux:  "2d1805bdf4d85d5b90c6faba650fee60846114a9838d0f9bf9912c02ebdc33a7"
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