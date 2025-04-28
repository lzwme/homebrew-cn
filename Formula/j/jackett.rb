class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1828.tar.gz"
  sha256 "6e43e15e6670c9cad1dca640d3c810acc9416e9a42fa9e4ddcbca4e3a6a2ecff"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8e037ee394e4dffaf458709ee4f299807e436f67af93048f50bbc1285d4abea0"
    sha256 cellar: :any,                 arm64_sonoma:  "961e1d39b1dee145cb28eefef721b5d83a3dca22f0917a9a92aca281ad75e401"
    sha256 cellar: :any,                 arm64_ventura: "80bab76e76a30180aa3158676aaf593059968e40037e2cd9895ac1d3ba07ccf6"
    sha256 cellar: :any,                 ventura:       "6317891cdcad306f3f0458d9a1bd4a0d0b7b9b1aea1f3653f3e5701cfcdab319"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f734d526614f8f397688a19bedafb5af80a218b479a71662254d3721d6d89df7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57bf415a323600b5ea507aa77dc3600d76d6ba3e8efb3c9f169700c49bd833f6"
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