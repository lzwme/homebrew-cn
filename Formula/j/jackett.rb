class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1136.tar.gz"
  sha256 "28d4bad4ff28b329bd5849c17e066356fbdf874ad314e31c15048ae50ac984ec"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "99a4c17eaba1ef65f2d460b06e8f24ead1b18236592653fe5e92061cc235bab7"
    sha256 cellar: :any,                 arm64_sonoma:  "b62d503cce4c91ad17791afd523fd1e154e23bb13b44479c19fbb8d905b99cce"
    sha256 cellar: :any,                 arm64_ventura: "6849f361568bc920155ad9ef91762196370c6c649d236b1f0bf9184be8b89ef0"
    sha256 cellar: :any,                 ventura:       "69b57bfdba99b63b017f347c54f80545fde8ea160f8661e141a76685ca5ce4a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34e60540b8bdb96d797282c2a318787221fe8d1a74c60a7f4a7f8562a2ddc734"
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