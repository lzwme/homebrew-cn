class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1437.tar.gz"
  sha256 "dc6adf2bd56710a03031fcd88bf75de6f6eceda476357692e406b903c1dd8269"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "996af097582f6ddf5d9d30ea4860f3e61d422b49945a79610d8e87e0261bca80"
    sha256 cellar: :any,                 arm64_sonoma:  "487c724b80d4ed4ee29ac5a31c405e37339b62ee3b4d81fbbca9e45a6b9b4a59"
    sha256 cellar: :any,                 arm64_ventura: "693586de82a5deb0520eb9c515c86bff0ca4a975c570596c37f39633e19119c1"
    sha256 cellar: :any,                 ventura:       "01243f76aaa4112bce1b17ace90df464df8e30784d469f96e27892d3505a8f24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53633c71359ab69c111e6d3d21d16db2f0dc4b1d8b491a21224c13eb5d4c1de6"
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