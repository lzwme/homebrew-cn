class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1552.tar.gz"
  sha256 "a3013dfcf45d3240455e6ed615333b1333353d25f14895d35e1919460499f867"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d5a9724559b4332f8f54d01482f9ec8964f41af52873d3e5a3bbd98220644156"
    sha256 cellar: :any,                 arm64_sequoia: "a801e219b4162aeac188e92a4558a470cc45b0f4e400a6c4b32fc941bed86d5b"
    sha256 cellar: :any,                 arm64_sonoma:  "0aed3cc47be0a3a2a5877d69b28a88a3bb7b06ed8a861f4078df7e89b4fd9221"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30d3bc426320ff1551d8cd9914e0848a97e806551aab929167153ddc99af0bce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ab3875f9dd95179eddc7542d42c2dc3d7bd406764a6bb0e9368a75fdd070a58"
  end

  depends_on "dotnet@9"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
    ENV["DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"] = "1"

    dotnet = Formula["dotnet@9"]

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --no-self-contained
      --use-current-runtime
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

    pid = spawn bin/"jackett", "-d", testpath, "-p", port.to_s

    begin
      sleep 15
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end