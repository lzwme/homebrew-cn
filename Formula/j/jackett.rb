class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1938.tar.gz"
  sha256 "5c5c3bcdc9f0c66a2c0b8422556db712740eaa48cf6aba817354cc494bda7452"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7415cc4f9d5392e0074b0738576a6ea3fdbb864f1ac004a5f82bc00ed54ba210"
    sha256 cellar: :any,                 arm64_sonoma:  "850ebad6bc7e0621f8bfe8150f28028350693c4f4fa92d04941f4ae8058c93c1"
    sha256 cellar: :any,                 arm64_ventura: "9068304d1b297bd6d4d49ad97853e1dc32ae31844109783c507f4ac7b6bcc0fa"
    sha256 cellar: :any,                 ventura:       "7d3e441c3c04f5fc012018e3179367e735d0fdf9c4b33c6a79265934b12d52d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fcb474b8c669c546c51d7db79258afe5e0814a4ee3fae7e7c85850fd8021a164"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07c678c420aaa6674635e9ad1e9d77da142ba48a81b3ffd712f4887be575393b"
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