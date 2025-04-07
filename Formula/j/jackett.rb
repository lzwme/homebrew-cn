class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1733.tar.gz"
  sha256 "49ae4461436eaf50540221b76f7ef5f295516bb15388510e6f98b8050e78645d"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a8002ef0478c7e47b61775e9cdcf92327c8f4dc60f395f63472f8dc8ac3ad25c"
    sha256 cellar: :any,                 arm64_sonoma:  "cac20826f689cad2fb56ca9efda58049e5b1fa69054d43c833bad1da604977a0"
    sha256 cellar: :any,                 arm64_ventura: "8052d979374bd32f65b558b91fba374f65b107e9089d6bea7b1c75a04b6b10f9"
    sha256 cellar: :any,                 ventura:       "e2f9b9d3e39422a195b746884a484f3cc1ef065f0d429cc8b0f3901af6b9fb2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5012bc04ec507a796f7ae283a7b01a79601abb406f3609aee96910916847bf4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78fe360e323daf0c1e878e12aed11cf305ea37cf3d43e449f0ec5bd923610073"
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