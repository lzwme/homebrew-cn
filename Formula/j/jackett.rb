class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1791.tar.gz"
  sha256 "e4fca661d2d0a4fd8a2954cfae8c508f5c23b1674dc061ab7615f16aad8a5820"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "714ca75c824fde53b3edbd6067e0fcc6028c9f44b7ca18d16326b6a01ecf4fa0"
    sha256 cellar: :any,                 arm64_sonoma:  "97e68be6f30cb4ca200d5c2c858b22d1d7e2ba3dd40aa49e42b5928c4a34fe0e"
    sha256 cellar: :any,                 arm64_ventura: "d1368ac84bc9243a743efefa97b803aa7ba1fe65dd63c6d31b3d7a4aa45d400e"
    sha256 cellar: :any,                 ventura:       "7603368f0a88788952e0918810be98d314e96353a3232181fcb8357228e29604"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc9c8b00c7156898adb2964435c8fbc3af62df5a311344f9dbf344855ff98e31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50d66906c455cd8af16be88df674f108c3df0d27b559d1ada55430de18e6eaa3"
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