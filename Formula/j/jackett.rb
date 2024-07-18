class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.339.tar.gz"
  sha256 "ddefb964da3c820111f9f21155da77e6d905226b0e4aad681c2e45457de9137e"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3d11cec66ca62db20873215dcc548abcd2cff5ce64df44d35676e36403db5d93"
    sha256 cellar: :any,                 arm64_ventura:  "1e5375db93eb772fdf1f031bc3cf90259e51df519a1053e270ccea26e0a9a7b7"
    sha256 cellar: :any,                 arm64_monterey: "7399662bcc44277d40edc0b108d8afa58fa50471b7ad1f3d6be4f90df2ab8e2d"
    sha256 cellar: :any,                 sonoma:         "23634d54dc3eff980ca8c63f48ac7ec73f24582a18907978f32a01a9fb4dba27"
    sha256 cellar: :any,                 ventura:        "62f03399b226dd41f55996140fd68af0373b10ef2a1c940048e015112320d1f8"
    sha256 cellar: :any,                 monterey:       "d8ce448998556a61173d17d2594fb7f8618033360d954ba83da8406e1455efd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d0011ec9bfafafb4c1cc0a18e73479775dd18cd77a5ddfd504891b032e6a2ac"
  end

  depends_on "dotnet"

  def install
    dotnet = Formula["dotnet"]
    os = OS.mac? ? "osx" : OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --runtime #{os}-#{arch}
      --no-self-contained
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
      exec "#{bin}jackett", "-d", testpath, "-p", port.to_s
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