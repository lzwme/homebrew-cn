class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1066.tar.gz"
  sha256 "2cfccff96ae5a666d8802e445f09961b00718f11f2240d3f8d99790c0a63e9b3"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4dde5a2f439f790327770237530803b8d0f2eb1047e83c33df6293b343b1a08b"
    sha256 cellar: :any,                 arm64_sequoia: "f9f754eb7bdb0c1e027402378fc06c68933613b894e93f4b5cabb85f82f8e15b"
    sha256 cellar: :any,                 arm64_sonoma:  "85827e9e97ede7ec81701f5b928732810e035ce983c315f5ca2d77e10f5400f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c51a5969b1cf7e44a69b523b392fd04047fcd2ddd5b21073885224663a706762"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c7232653c6a4139ae2efa5fa17ba06e72745c8427c17b4cd14612e9a05e4375"
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