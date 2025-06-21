class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.2032.tar.gz"
  sha256 "86bcb7d700462032dd33ebdf14043f2eee04872feabb2cf479a7367e8251e7ba"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "53c88719fbdc91538b09d8564df5508255c7759d2b0f8ee377f6f23e599dbf23"
    sha256 cellar: :any,                 arm64_sonoma:  "04f5286bd2c6ab7d745e418a114e6b3873f24e1004eaf0df74d22aae313360c7"
    sha256 cellar: :any,                 arm64_ventura: "97aaebfe2349238d265c92dbaef4e1b4dadc9124c7a718755fe798739b5454ac"
    sha256 cellar: :any,                 ventura:       "746a06e0db43188812a0aa808c4cd601923163879fb7eab7695561004bc9ea1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "278a425f7f133e596560057b82a56100933157472405cdbfd3f29e0d13cde5d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ad1bf8be1529a86ffa205f5a1dd8c99228d03a9937a476f30c420af2dc89af3"
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