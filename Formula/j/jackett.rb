class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1984.tar.gz"
  sha256 "d5742ed81d8b1aeae3670002dbd40c403525bca803490b8296bdfbb6a1ce8c0a"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e220e7be9ba64059103573c3389352b807ff92aa60c5521220a9d6e88789c94a"
    sha256 cellar: :any,                 arm64_sonoma:  "9fb94e70569004553a8d32f9f4c421f4965b7fb0d2e78b90b926c73d1c47e9b9"
    sha256 cellar: :any,                 arm64_ventura: "ca3a6bbb1673a19c60abec99ae45680d969bfb27952b92a64caa454676c8e084"
    sha256 cellar: :any,                 ventura:       "6589022c12bd0b4bc0c3a087f0058a1c63b0b357a93558e46d6b667c1b958196"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c54ccc308a7d71558182d9d6dbbfb940f0bf271c5841319c08e7c012efaff99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "759b68685d9ed4ccab98312499d060eabb097ff8fef4172f6fd47e056133b10d"
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