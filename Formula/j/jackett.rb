class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.206.tar.gz"
  sha256 "fd23f934607709cf6a2f584a05f1902ccb9b498110698e1200bda60bf307abe9"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4c0aafb00d0674bc3e1f444d1798f98cb881b464a52ca0b4c79a8e04fb74d815"
    sha256 cellar: :any,                 arm64_sequoia: "be5e4e42a57ea7789474ad76dbce7a5b01ab9d9c29903d5249c9e95a54a4f7d5"
    sha256 cellar: :any,                 arm64_sonoma:  "a1fffeb4289dd86b5601317502ddc997aeb87fe6bdd8f2fd35840e4e4c9196df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6717ea2521cf9ef30d8e495711fb4b08068257e83483f18c566d058b50d52f15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "812f01a192676c1694c028d56f85c6ab560cec90741fec5d3e4f3d944e6bc973"
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