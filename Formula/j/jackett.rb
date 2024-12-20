class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1096.tar.gz"
  sha256 "e49d153666292f6f563119420a3bf4819da4f27a68fb886d4d97d27a4d9b2d12"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "dfd1192b2a4bc1bbb10a240bf79eba2b61c4415639a5d4b6b513e1da37cef44f"
    sha256 cellar: :any,                 arm64_sonoma:  "3af9703610663ba5e59daef5da60dbd2d2cf52ed8d1dd06a8fff4e9adedd6c20"
    sha256 cellar: :any,                 arm64_ventura: "038931bdbcfc9acfcfd892ed312eb3da6146135f77997fbd2f8a2ff0e8f00235"
    sha256 cellar: :any,                 ventura:       "ee9905583d277f3661a786d0973748659091cf1c808648be99202a3b73b481c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbd60593fcad3ab9999ca4d93a67c42ea6da4c94388fd3cca4394de8b533ffc7"
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