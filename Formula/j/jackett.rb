class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2231.tar.gz"
  sha256 "4a1584893592ce0022bb2bdc11a365620aac8107cb32d269f18c5a5beae25bb0"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "342c782ca3dc5da227c175e23f1f932f4e2ebf15e3a8fe5b4a9d83299883a483"
    sha256 cellar: :any,                 arm64_sonoma:  "82026bf68d4fa115fba5d2649b192e2a4d18ac701031e760e7f38a8243ef62e4"
    sha256 cellar: :any,                 arm64_ventura: "83a6123185b4c4f5b6d5cf9feac8421bc8f7c77073fe9ce45a498cc416b71e39"
    sha256 cellar: :any,                 ventura:       "72e3ed7de9bcef3345273ca2ff9cb8de1e3901b2d4a5bbcbf71100338798d70d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "228fec1697d0ffc7caa1061c144de60650195f1bbe2e146bd19b1945e03ef814"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bde437c72fbe79cbf60cc72b81147e8fc7e76bee019dbdf05d270533b9b04c09"
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