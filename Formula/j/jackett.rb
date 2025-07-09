class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2132.tar.gz"
  sha256 "66a57137018caddc94e7889d6e53eda113486ff8c22add800cc74899464556e1"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "85bc4b3cdd1db4fdd9b1af2faedda7b41ad35653e8674b2a0040aa95b973ac8b"
    sha256 cellar: :any,                 arm64_sonoma:  "6a53a40fb57f614a54822f7d00a6b250447ce9e7c72ca2a8b2c3c824d464cc0f"
    sha256 cellar: :any,                 arm64_ventura: "a5d179303a9db4a6d8ed59bfe751838d1b5d3685da4608751d0d3e8cc574e614"
    sha256 cellar: :any,                 ventura:       "21a7d2d956e293c687f65b37cc6a0ef8940388e50419fdccd98892022caea91a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7027d4c78601f578527669edeb33381a042eec846a58f1de420323ea8d292b47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d0e3657269fce6ba503edfd143ae933c69d7e473f916b6d3efecdcd9f31ac43"
  end

  depends_on "dotnet@8"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
    ENV["DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"] = "1"

    dotnet = Formula["dotnet@8"]

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

    pid = fork do
      exec bin/"jackett", "-d", testpath, "-p", port.to_s
    end

    begin
      sleep 15
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end