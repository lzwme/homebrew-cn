class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2282.tar.gz"
  sha256 "dce9a8cc531fc788a2a558002bdb652ab7f2215ae3e18238e7ce30027323c1e6"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8b0dd86dc33cc62c38a2e90ae94cc2bb7aa9fb514859e24e7cc2f3e9a2458dcf"
    sha256 cellar: :any,                 arm64_sonoma:  "88697b406f4e30aec70f72e45fe14f72aa3546b44a149040434d118a37d4db6f"
    sha256 cellar: :any,                 arm64_ventura: "6bca96d7cae7dc7288158752a123f2fa39e2c846db38a30370a8f14425612f0b"
    sha256 cellar: :any,                 ventura:       "f1902891d491b5d25ec7535d17ebbada3c842b244e054a3a43f2bb11c43f9103"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2da5682c418e448c5a9305a6608d5cad0687f4b1831e45f86dc27547b0e2adb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "449da107da49bbf813834a02760f10443510d9c796d83274f8eaa4a305da3a06"
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