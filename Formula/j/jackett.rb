class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2315.tar.gz"
  sha256 "f8af69985c5364ac6a557d805c43b950270fea8f011438d6f1477ab174525adc"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e7602f63dd906f763e4ac7e82348fe8fbaa3f10e367d854a24ba3e835bede770"
    sha256 cellar: :any,                 arm64_sonoma:  "5369439eecc602f06802d2ee0822134957f9d7ab88ecb3ee8f6e217dd3a98922"
    sha256 cellar: :any,                 arm64_ventura: "78ccfd05daf088ecd12c21a3f098730b426f480e35f8b3226bec07b3b9661106"
    sha256 cellar: :any,                 ventura:       "e2f78095efdb3478428c204a43a62c5e90462bb8cbc557e8ef1ee4142480c6d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3225520d6b298aea50ccc99c26e4fee729dd25d53e2bfc784edff603cccffbc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03d44afe136995e15772d12c870eba89e2aab6657e7cf3e72ba3c24b95553d70"
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