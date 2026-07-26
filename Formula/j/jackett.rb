class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2267.tar.gz"
  sha256 "0cef8deefa02abd2c88da78a31cc02603e0aaa197fff495333f0d2405ac75614"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "767baffdb8ffca92e476d65bb75ce6929bdd7642ae6ad2dba5f1a74716c3ca06"
    sha256 cellar: :any, arm64_sequoia: "bacaaeac3429eee66e2c162aa98f64e37453d89ee4d94f91f5f5253444422b7c"
    sha256 cellar: :any, arm64_sonoma:  "15df5ae03a8fa630875bcbcad5845f4b501cef1a057ec550d5290b03961b7421"
    sha256 cellar: :any, sonoma:        "3873c86a560e9558af9579f3e448dc27c9215bfee09b60670caeab4c5356ec20"
    sha256 cellar: :any, arm64_linux:   "ec8e4607c63db204abce44e607bdbf4a9d87d91a2bb743805bc8d7d89b91d3df"
    sha256 cellar: :any, x86_64_linux:  "58df9f0f3329099445aaceabc93569a68d1aa67e8190dd13c4500c7ad52de69e"
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