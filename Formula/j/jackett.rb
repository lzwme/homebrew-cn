class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2235.tar.gz"
  sha256 "4eea8de77cf2284bfa69275eda93470a35de84c2649de8520c7fe0e69ad8af95"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6d96471eac3f3bff5d42005506d778972b5dd289fb46f59cd4735a0e238c28a3"
    sha256 cellar: :any,                 arm64_sonoma:  "03e660bf251c8797a765eac10bf908241ea6c2627570f0ec20393112401b35c3"
    sha256 cellar: :any,                 arm64_ventura: "aefc62bab18d68c487565292791b71fdc667dbb1b9f6b1fd950a26e0b3ddd4e4"
    sha256 cellar: :any,                 ventura:       "6739e299f507cfa2104b72209dfae42ed0904a8c3714db8dddcf34f8bbdebc35"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a962ae6868f0562b502b0566a3c0b27b79504c19321e5e3c4b320d6bae60021e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85f6dfcea4f64c288b49a6d7fb989b68a697e6f788513a86768ec6f99fc05a38"
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