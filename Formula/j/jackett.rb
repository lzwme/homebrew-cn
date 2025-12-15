class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.452.tar.gz"
  sha256 "9292ef440f8210bc7d5b75baeb1956015e32373d80a7e8ff09a9e597bb5e066e"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2703d3a141ab3b571294ff1d71ee2c57fa9341f727320523db9399090d70c701"
    sha256 cellar: :any,                 arm64_sequoia: "3244b53658feda794c55ab67b483d59d2e46b82b94b6525b629f94d2a5478eda"
    sha256 cellar: :any,                 arm64_sonoma:  "b963babf7cdf86cb7b2f8403e9efb3420a7ab5ef54586b35e1fda978efd229cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "73d4b2c32df6272d7637e1b295a671665aea9e29d13cc881df61435a83f4ffa1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4afcbef01df9cb78079063429148670fc0b94105e48f8513961913f3960d1778"
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