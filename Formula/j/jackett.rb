class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.221.tar.gz"
  sha256 "839893fb0eb06e673ce53d89feaea3d70aa58dd17baeed96847dff9de500cd42"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "dff81ba610a7ed66748936f975cf4a3227f3901004951f986d3b9df98d6f7e80"
    sha256 cellar: :any,                 arm64_ventura:  "530c78cb73ef9f14a0d36ce2c7b5e268bcd6a1d6da9a2bddce37c220976a0ead"
    sha256 cellar: :any,                 arm64_monterey: "817aafcda2c30218ef36b348eaf0b0b8fd5ee3d73685ff909411887a3d756165"
    sha256 cellar: :any,                 sonoma:         "ef0e715f428de89e6de65377aab6c4ddf10f334e0a85bf4a4e61f108825a5754"
    sha256 cellar: :any,                 ventura:        "e3718beef8c557e4a19cadca624ccf1573b18cd028118f0a1e39b97d3cc4a051"
    sha256 cellar: :any,                 monterey:       "8bc6d8da126d44d9c19481619495b055df29770e4d8b5c951606c7335506bc4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93f0fa17f85610088e83864b4392369c12432380715a0b193c8fba0d27e6e3f9"
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