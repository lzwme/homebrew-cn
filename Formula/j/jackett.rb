class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1239.tar.gz"
  sha256 "53dfd30b50ef1fcb7481ead6d298646d7aa04c3dcd99b06b2fde9c1bcbaa51f0"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "99932455d373d2d9a6d7f25bf355ee3dc9418527598bf4fd89a4efe2c386b437"
    sha256 cellar: :any,                 arm64_sonoma:  "ea66741e6aa58721c09437018c37cdbce7f74c36d0658376c0d672ab208cd758"
    sha256 cellar: :any,                 arm64_ventura: "603302cd1e6149aa4306d360d9751cd42939a44e21aa49a572d1a3eee12e3666"
    sha256 cellar: :any,                 ventura:       "64bd64d1e4150689afe1c353e2d1c587469fd013ec71a2c3aa1d18cc3d8c0547"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "552b943b6f3566eac06b29ca48a351674666b5247de7e010096f051e7deeffbd"
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