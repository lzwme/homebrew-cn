class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1787.tar.gz"
  sha256 "21d71dfe0725167dde1105652ee0c54c81a0f3345371479df05f3eba8f890a33"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e7b95b780d42b730fba28e1e4007fb4d6abc4415ad33b7567d2d31295877a504"
    sha256 cellar: :any,                 arm64_sequoia: "173dc9b331dfb971b90516d74aea6e30b071e5be51fef94633d760f0885327d3"
    sha256 cellar: :any,                 arm64_sonoma:  "7b4b27a371336508fa3728e9e49c85e6051a04c6b0e01136cdf37a6088a6e682"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2b123ae26bc4c910ce1d2c844666512bc70b72263c2e612387e00c3da995859"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01cd06fce393727edb623211e1ae8f61e74977fab0136887a0008cecf33230bb"
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