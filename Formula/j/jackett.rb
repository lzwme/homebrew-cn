class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2321.tar.gz"
  sha256 "7c17b83733ccf16f854ae208ea2d3fdbe1870a496daa9cdb3cb3a270fd9ac220"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "28f896e6e6efb1916dae420183755e48307976556dc0b75a122d24d33e6d843b"
    sha256 cellar: :any,                 arm64_sonoma:  "d2e40e938134aad81e401766c3f6a4b7656872fffecd30dfcc176e674977adba"
    sha256 cellar: :any,                 arm64_ventura: "22955738bbd9b1eff5b54e8f0a08d74b542408b0aa30825701aeb2d0c45c30bc"
    sha256 cellar: :any,                 ventura:       "d88e350eb247930568cdb4f4a29082eea2a3697fc4726dd2663f9963c20498e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1dfb9ebe0d090dcb12af878c92bf691de90a59c5d65e3c9c378a6a5e39436284"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ef5d8eba009f5bf597305cfe1e39cc5dcead632089fc2ab60f8303712ea4ba1"
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