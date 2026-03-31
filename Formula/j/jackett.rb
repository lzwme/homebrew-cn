class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1489.tar.gz"
  sha256 "a807b082e2c846483ef3102c4a91d0fb92a894836d923a68492cecd9bb5bc9fa"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3a5bfbc76ce44a377b9ddc760ef978ab4a2732aeddeccdecb1e155f75b05f02e"
    sha256 cellar: :any,                 arm64_sequoia: "314081768960d9ec725768beb2df55ee5d581c8c76bdfd864f615505af5e454a"
    sha256 cellar: :any,                 arm64_sonoma:  "fc5b85b54d055a59bb9758429988bde8399a715e960c32ad2d1f44d067a8dda8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "282005b363cded723a57af0b7cd7eebb97a4c9c48e5b7a4da71b03ee6538cada"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20c0528464d92812dcbdd72ccf796d61787c4c1c4023bdfb51430c0e6bd24915"
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