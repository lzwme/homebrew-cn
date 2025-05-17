class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1908.tar.gz"
  sha256 "cb0c2f25539fec0c1edfbb0358aa45a390e160bdfb9044177252ea9dbcc89caa"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6569674a7c7a34ff69498f6426959d8cd1e028562f828d80439155e0bf11aa50"
    sha256 cellar: :any,                 arm64_sonoma:  "7293041faa1fb6a65308e047f81ce2316eb2a32108303c36bb6a150b4bb00a08"
    sha256 cellar: :any,                 arm64_ventura: "e6581b9036b6c0e1240c98be9ce781f63828f81b5da5905039cf9ce9a6e4630c"
    sha256 cellar: :any,                 ventura:       "a498eaeb2db65e162bb3d8d4e6701e30a56c65d2b5b1dc4c887c1469aa9e2bfc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13248701861d3bb2f8b5ce56870d84068317da3cb62138c667c9995aaf345294"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e4a4eaf3d565e662545ba561441e531c89ff4063cdbd22403b69929b8cb3d2f"
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