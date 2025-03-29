class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1702.tar.gz"
  sha256 "8a577d960e34c42acecd59feafc8a6d206e296429b5137b9727e4a0407775ed9"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "369c688e596979d0ab4543ef2fc00a2ca9de0f578f263c29141db4e8668d7380"
    sha256 cellar: :any,                 arm64_sonoma:  "19168d9c051fd12d6b7bb5034481349945c884722ce2df5d99aa5e33e63f7fd7"
    sha256 cellar: :any,                 arm64_ventura: "e968db4c1a9966b5d98c74b03d536e112cd5cf9f94fa3b0507dea25386f07c03"
    sha256 cellar: :any,                 ventura:       "22a6070e5d051c74819e18b061ffb97ae7c9a4bccd6431cbcad4703773cccf6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a6631a20e9ba3cfc3c90090132adfeb2246d4b782989327ab00268f87ef4e84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92350839621cf119711ac796d7b37ac81a2402fb1367f26a238bf178c65eff82"
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