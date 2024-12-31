class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1150.tar.gz"
  sha256 "3d608ff73d36c29e93c42d739bad32c2b39cd830c2e2cf3b94b8d741d279bd36"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6080ff88762a8b2e210de9616cb67c485ae6fe336e4d61dd09561a44fb6cf150"
    sha256 cellar: :any,                 arm64_sonoma:  "05e4e98adfc2e4f84689b3c9f862ae9408fa66d97d6900294b9a998cc5649e09"
    sha256 cellar: :any,                 arm64_ventura: "e357ae13a228bd0d05b0e8b1458ae52fd6e1c02fc122a9ffc1ffa4559f2d0cb3"
    sha256 cellar: :any,                 ventura:       "2ef8e6da50d362594359132a722086fe807cfff90485ee5c654403f2f3f2dedd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4f8c5acff9f34406facffd9b0c5083cb1b2eb27910dd8b3ef46fe27427c240f"
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
        p:AssemblyVersion=#{version}
        p:FileVersion=#{version}
        p:InformationalVersion=#{version}
        p:Version=#{version}
      ]
    end

    system "dotnet", "publish", "srcJackett.Server", *args

    (bin"jackett").write_env_script libexec"jackett", "--NoUpdates",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  service do
    run opt_bin"jackett"
    keep_alive true
    working_dir opt_libexec
    log_path var"logjackett.log"
    error_log_path var"logjackett.log"
  end

  test do
    assert_match(^Jackett v#{Regexp.escape(version)}$, shell_output("#{bin}jackett --version 2>&1; true"))

    port = free_port

    pid = fork do
      exec bin"jackett", "-d", testpath, "-p", port.to_s
    end

    begin
      sleep 15
      assert_match "<title>Jackett<title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http:localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end