class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1182.tar.gz"
  sha256 "103df00e64c31327acfb9a6bec2ec48b29db90b6386a41838c2a3c30ccf717bf"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "658644e645444acf83edad8db8349b7d1c3ae99085e1ebca5f23d5b92f78eab8"
    sha256 cellar: :any,                 arm64_sonoma:  "64013e90a4fb96ff8cdb6f162471366d339a1af9710f5cd0a2d88de7b3e8faf9"
    sha256 cellar: :any,                 arm64_ventura: "f0b27896bce41df7537f4b687a00dec20ad480edcb4c6491be2ca952394bd7c3"
    sha256 cellar: :any,                 ventura:       "ffbeb328eb0f779827c2948eaf8e67fe0177161e62becdaf09e382ffc56548a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec1013b805eb07fbd83b2b47175d6fbd41c4c169a28059adb1d1c5ee0c30bc8a"
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