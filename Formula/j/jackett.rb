class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.666.tar.gz"
  sha256 "991898d1259bef4fc5ae2ef5237d04bf6a3a3400d6a8c3f43feaf1a20ca65a63"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "e1dc1c791005b3adee6d9a0c531872d556f50907b53012be1d6230a470328b06"
    sha256 cellar: :any,                 arm64_ventura: "077306b41c83e86deccb25e73bca765e929cb622100be0083fb833d18fbb43c6"
    sha256 cellar: :any,                 sonoma:        "1f1730dc180fc122c36b379acc95d0f1de996e552b8b54651768f95145b8d16a"
    sha256 cellar: :any,                 ventura:       "645cdb3ff595d9dbb5d811904ef7da04d654b36146298b5daaba50ff949c90d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8d9b027de88d5e7871e910a52a04a340306d201e4701102f9c8b8b4a932a0ef"
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