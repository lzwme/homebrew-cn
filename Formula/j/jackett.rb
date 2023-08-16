class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.648.tar.gz"
  sha256 "575e6b8006d65018d7a88505311b6913078b616b7871af9db82228b53e201e7e"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "54d9349b93a62fdc35413853fe079abadc14558864e67fe17540600997105fc0"
    sha256 cellar: :any,                 arm64_monterey: "912315616c43a640a39044b4f756b98142fe18e6e4c2e3e474aee0041435096e"
    sha256 cellar: :any,                 arm64_big_sur:  "e8d10ebe67263ced40ebe30b09f5790c6c826ccbd548714ea08942347e32e349"
    sha256 cellar: :any,                 ventura:        "10020daa990e603702aac2de85f40a7d4baac63be1cdc71e0c740309e755dd0e"
    sha256 cellar: :any,                 monterey:       "c9f0197eee7522d57a4acfcb99e7f493340ab82569b3295670e2ad91aca32519"
    sha256 cellar: :any,                 big_sur:        "f1add2e7e6f5fb3f3b1300eda43973200398d84f671a08ef998d3d884603b0b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22592a8e2413c332767150510892a9639f40b81e085549613777bfac6475d7f5"
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
        /p:AssemblyVersion=#{version}
        /p:FileVersion=#{version}
        /p:InformationalVersion=#{version}
        /p:Version=#{version}
      ]
    end

    system "dotnet", "publish", "src/Jackett.Server", *args

    (bin/"jackett").write_env_script libexec/"jackett", "--NoUpdates",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  service do
    run opt_bin/"jackett"
    keep_alive true
    working_dir opt_libexec
    log_path var/"log/jackett.log"
    error_log_path var/"log/jackett.log"
  end

  test do
    assert_match(/^Jackett v#{Regexp.escape(version)}$/, shell_output("#{bin}/jackett --version 2>&1; true"))

    port = free_port

    pid = fork do
      exec "#{bin}/jackett", "-d", testpath, "-p", port.to_s
    end

    begin
      sleep 10
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end