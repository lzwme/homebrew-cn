class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1123.tar.gz"
  sha256 "709e51300fc70caa5c2be2f606174018df535ef3ca5372e5dc070439c828dff8"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e96a6b69e71aa116d04f9ae3efecafd367c51926808bff1226e190ec5b414b1f"
    sha256 cellar: :any,                 arm64_sonoma:  "7564e6216087f9d2ff41e58312b3936f3bb414858fac85c81292164d2fa1297c"
    sha256 cellar: :any,                 arm64_ventura: "603943423adc35816123ec2713cf6a7a1bb62d4947c0d78183056eb891667bd7"
    sha256 cellar: :any,                 ventura:       "056f3192261de41a4747327495605a06cee3420728a5a5c7dc282da94751a163"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3e6da238dda2dbf95bfcde551d7ad1c62a8fde91c496e0f28ab84dae1aa1d08"
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