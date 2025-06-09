class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1999.tar.gz"
  sha256 "9e4451fd6c1af1787a1e2ec251ece0503e92bfb26bf76afa9920da755344a79a"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7f23e7272fee0ebf945400674dd7a2e0eb07f989bed2ca240737870f0af8f31d"
    sha256 cellar: :any,                 arm64_sonoma:  "abd774580522ecfd8f9db3b68992837076fa1b42b6233773a07c8c81ed6ba680"
    sha256 cellar: :any,                 arm64_ventura: "55948e7a071e20be058ce5f75a4effe47a2f335a03f97aa4a2c0b878fe7d06d1"
    sha256 cellar: :any,                 ventura:       "aacc66e229f6f56717e78e1d50d1848e070f2cd29b019e16a2b663e9d0dabbca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5cdb1576a9a1e308a76850814d12f8a96c18089379337611682bf49936070572"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6df18a6d706dd08bcb60d6784ef65f349c8c87090a538331d2d61181e0e77519"
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