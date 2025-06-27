class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.2056.tar.gz"
  sha256 "d27510e4e58d09de048d6df145e3ee255a1ac056e4015d6ce0e720823fbd011b"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cbb5784263401d0e855f61c764f7c5db200b661b0947eff80b05bf491bb91b33"
    sha256 cellar: :any,                 arm64_sonoma:  "42896395d3a92445817f1c5fcb89314c6dd2fe007ef60a036e57a3019dd7681d"
    sha256 cellar: :any,                 arm64_ventura: "ba599358bc676f4c7de3dcc26744eff372a7c805d54fff6c28e4533eb174ea61"
    sha256 cellar: :any,                 ventura:       "a2b6283c6ad6f78bb2e49322db00253d63f2e3329e116709693ae2fa41ffd1f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb1cde74e59504a5d04e6694f3a71457440a24666cfa155d6704efb976e89e6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ef553a01ffc4d1d3d65bb6edb806c71ac61a49e8037692d2fc41a979e2895f5"
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