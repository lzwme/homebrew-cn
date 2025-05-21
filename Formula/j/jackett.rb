class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1930.tar.gz"
  sha256 "20eb872c7eb52d8c55f973e0e1ea14bff7a780c6c8315b1394e514bb338cf426"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "93fe126e6c24d5321747832d9be494f8981e1e92a434e3d8e78f809212c3e6de"
    sha256 cellar: :any,                 arm64_sonoma:  "f97ee920a912d2f7486f4e42cf5314e9f590255583eae068d3c64a3e83cd0712"
    sha256 cellar: :any,                 arm64_ventura: "a50bdf9ecaf2fe943b9f708698d33d0ee4d99a65812d8f686bd72224eae44417"
    sha256 cellar: :any,                 ventura:       "208a59e9cc72bb590772d877f4127d3a62ca92e9b95e6861e858e627c6c16e48"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "050eae01631e0b5caae70ca13dce5267f63faa778a2a0c52f46d357d63365d1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb96ec828bef5cf57d749ba4b16fdb41908576cbcf0a7e4563ae8db48ba15e88"
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