class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1691.tar.gz"
  sha256 "5fb813836fd6095933f092b3e445fdde9f9b1d1e46b643c022979c92defb06e4"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "77a89c2bf987671b4dc59d4e9e258869c25c7120ca9fa031eb19266e2dba9661"
    sha256 cellar: :any,                 arm64_sonoma:  "dff5a7b7065201f4ba12f3b3a1bea1c44ab96d06de7c24be56a00fe21a803820"
    sha256 cellar: :any,                 arm64_ventura: "190dffceb421fcc65e1a1f1b0bf462869e313732c43fffe3e305b442c6366cbb"
    sha256 cellar: :any,                 ventura:       "47a203015526851729d485b3c67d4e78d14f829ee578812473e7ad6d913a21c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4e1f463fdf5314f0cb8806dad774f2bc7cd510107ba67775c71bb2d8bf722fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31c6f671c60cd33a5d82af80aee2f46c37366ba76697b7eb9485f8bf4bb36e27"
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