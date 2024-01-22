class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.21.1585.tar.gz"
  sha256 "cfde4a3bb542ff743cb94bbf1754415e5ca4f355e8e119867d7a494168c08b93"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "69ae3a0437407b373d0cf8e9810cad4c097f9f7dff1082c752d38b13b80e5214"
    sha256 cellar: :any,                 arm64_monterey: "54e097d66b2085b023de63dd87142845012ecc4e4e315248036c68c383dcb962"
    sha256 cellar: :any,                 ventura:        "aac2d93a57d7d0787578dc2d34c23bd5600d5cc72024cb563821c54aa0b3c757"
    sha256 cellar: :any,                 monterey:       "6334d86788c0e48c6979c787f6276b71186bab56b9cc74efa8ac2c25f4a79f61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a3928aff57ee1eded4d03b1f893442b7abe9ec166ea0bdc6c06ab9360ce43ed"
  end

  depends_on "dotnet@6"

  def install
    dotnet = Formula["dotnet@6"]
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
      sleep 10
      assert_match "<title>Jackett<title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http:localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end