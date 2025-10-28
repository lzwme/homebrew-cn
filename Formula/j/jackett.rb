class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.196.tar.gz"
  sha256 "37a2df5b6021dadaa7501c138c217b6ebdf85d99b26b757c37bb3385fb20a9ed"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "958b376dbeadf88164b5055c180cfedfece1c70b3e93130106279e26170a4fd5"
    sha256 cellar: :any,                 arm64_sequoia: "3418a26c8bc827eead51172fd9ca47502dbc1f541fa728a8c390d79ac6225321"
    sha256 cellar: :any,                 arm64_sonoma:  "046a50da631f23e7b66dcb6ebfc6d553602591ad21e53a9e34ca5fac292837c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9b3d264a1ac365bc2bde842d23c5774d000e6684a439fea04465e7595caf945"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13478ff34007450ae68970da5a2cd01e63a0697d97bedc211707960828a9e88c"
  end

  depends_on "dotnet"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
    ENV["DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"] = "1"

    dotnet = Formula["dotnet"]

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