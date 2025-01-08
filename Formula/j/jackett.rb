class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1213.tar.gz"
  sha256 "9b52b4d5b64e8fea53544cfb14f8abcaa90330d5042ab9682e3490f61178a159"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4aec2ccd4abfa147528262475b1358e5bf46b0cb4511665aed425f785ca8c184"
    sha256 cellar: :any,                 arm64_sonoma:  "89176fe05cf2672d4350dd4170908f6ed69c85f21e88828d1ebe9333ba23cee3"
    sha256 cellar: :any,                 arm64_ventura: "423f4299105f553d62b8aa56ae91bfd6d6a61a0569170f611e1c1114a1f437fe"
    sha256 cellar: :any,                 ventura:       "10a9f5478f18bef02596d3bd21ad340c88e896f2920903f7c87da31dc777443f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dcfc0a787503ddfb49a4e3293c8c7b4b6d83be4a06edbbe6bfc73155651755ea"
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