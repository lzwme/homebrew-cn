class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1595.tar.gz"
  sha256 "abbbf9ef97ae61f1189e4068924e7bac5e70d2027427570a77fb58236770ec7e"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cf9a32fe8983adb3845818dd92c938ff45e11ac260761d80da962b37a487ac72"
    sha256 cellar: :any,                 arm64_sonoma:  "71182de6a22561a05d59d26c401f9bb5557343d539501dfbd3ff32e8aee2e783"
    sha256 cellar: :any,                 arm64_ventura: "e368077ec5c12a11a03591d9ef20f6bfabc9633dc0dc6571b759eab89fc220f6"
    sha256 cellar: :any,                 ventura:       "e906ff4a6ff5b128ae9971764dc17b7bd0d657e16c30e4d978d2b10ce91a80ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "835cf00ec51ee43111a172103ca3934620754bcc290cddf7f0483c123e15bfb1"
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