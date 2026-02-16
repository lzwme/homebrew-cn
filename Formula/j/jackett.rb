class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1124.tar.gz"
  sha256 "6a178a83bee449ccded4f76a5bbcda3e9c9e97bf1ccff1ae0d50c8db6f5cda89"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8dc79d0735914a670054844cd1aa0b7719fe69a1521d9bcdb81fb6d00766f034"
    sha256 cellar: :any,                 arm64_sequoia: "93f3774d9da112f45bd96a7d0c9c46506e12d86723afa3ab167ce0dbd1912072"
    sha256 cellar: :any,                 arm64_sonoma:  "196c9cf5cbc40956b6308df4389e64efb6e48c0870d55028ec7f620dadcd6182"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15b3109acae1d59b37e608274c27dcbf1e5a0d3c49cf88b518d130a66be908e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31be7d0e5eca233ca08b74794b8707937cd6a99fa289d821f1c5bb8350d8357d"
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