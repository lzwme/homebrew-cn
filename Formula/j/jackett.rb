class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2424.tar.gz"
  sha256 "05d9e5a91c10060d10107b7c088423c570eb7e62a79b8a0d800d1fe105498552"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "05dcf0c64cae632152486d67840b35d17763abf1b64be90d729e38d3f0995b74"
    sha256 cellar: :any, arm64_sequoia: "f4ce7b86da75deebb2d21915e591f612236f30166215386562977e0edcd6d168"
    sha256 cellar: :any, arm64_sonoma:  "37282b76ef8d506226a36dc368a4c44a180d45bed3d33c1aa651e65b9a5f60f7"
    sha256 cellar: :any, sonoma:        "38925e2cddc9a1106f822edf4db18b2af4554a5766ee45ccee4e5e0e44465d38"
    sha256 cellar: :any, arm64_linux:   "56f944c0f04c23ff51fe1872fa272472b27ced04f76c3f4c23f5117237ae0ca0"
    sha256 cellar: :any, x86_64_linux:  "0d0f67d89f7479bc85d48fa46d0ec3e503b105c3345d21c2e2d54b53ed9b1075"
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