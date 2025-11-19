class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.324.tar.gz"
  sha256 "aa20b65c3c61bdf0c7eee92bfc8d609d3ef9c0d1dc0b25efc12031b8271baebc"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "793ae32564b03b5ddc9fec998c88991f520d84fba766c3d6c70dd34700a33765"
    sha256 cellar: :any,                 arm64_sequoia: "cc734ad1d459f42e4aa53d82fd7e59638f33eaf9389e9085bd304859717f2dbd"
    sha256 cellar: :any,                 arm64_sonoma:  "035b4816e658c7c32609e9853476d8d173b124411ebf73c7ded9c362ca649ad7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2c50bf5a3ec8c82228ee7c224c59e99c19d95f17e516f8939249b4a32859e37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7cd2fcf17253fc3385945125408189a0484196b656b1c632a8d42ad7ef4dc950"
  end

  depends_on "dotnet"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
    ENV["DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"] = "1"

    dotnet = Formula["dotnet"]

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

    pid = fork do
      exec bin/"jackett", "-d", testpath, "-p", port.to_s
    end

    begin
      sleep 15
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end