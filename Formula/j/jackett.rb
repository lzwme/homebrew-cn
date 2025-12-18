class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.468.tar.gz"
  sha256 "ed29063776159118209297833440f69b0fe22bca0ba719aa278dbed336d3e07c"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "787a11b2cb4b0859d5557ad9e927061b974f3c93bd4c1a79abfea11719e7ba4e"
    sha256 cellar: :any,                 arm64_sequoia: "d6a614df3d5e23057861d1fd744789a41df1f3745e562b2e3cbc73560c370f7f"
    sha256 cellar: :any,                 arm64_sonoma:  "798d6fe23a9c34d14635b85965aec02e1f91e204bb246a14759971d2abd7009c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "668127ccecc33ee3e40b0ae33e45fdc4487410ef91e529ac956fd22fbdad943c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18b8504899cc9abeb742e25379e7f080cc6d1d029560f6e58e5bf3b2b0f954c1"
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