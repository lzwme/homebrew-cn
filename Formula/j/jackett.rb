class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.436.tar.gz"
  sha256 "a45eebd6ea56270d08271c5c3ec17b80f32d090d046e6fec050c1c9560a32390"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5de99a7d728440d996fea36a227b31ec8296326a01683cb3440f22b1796e92e4"
    sha256 cellar: :any,                 arm64_sequoia: "78286bbd06843e6a6e06581cf36a979d06b0156ec12433a6a3ceeff9eb096962"
    sha256 cellar: :any,                 arm64_sonoma:  "66324c3f94964305fb5572e1b7dbb0bb14930167126b938ed97dd1e2d67672cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "021a554feda70478ecd282f630e2ddf0550b0947add6f947eba08c0fc44ef015"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fae59d8fc020a11132d4bbf626b40fbb540d7eacf09de73f2dee37f236c2ecf"
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