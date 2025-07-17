class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2161.tar.gz"
  sha256 "61efb1b12ea7bb734cbcd108eea978a0e3f1117eb3ff2c86fe74e65c3e11f5c9"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6d8ff666ff314c0e83a52bc93eaeaa5dbbf539e0c1111c36185c05c23abb652e"
    sha256 cellar: :any,                 arm64_sonoma:  "0063789dfae7135d8d82d35574c5a3f64aeb10c98ce93e6b298719012bdfc78a"
    sha256 cellar: :any,                 arm64_ventura: "012ff705cc4f48fd9bc7dd2295ee1ba85ed63ba97cb5b67666e63b08fda2ff20"
    sha256 cellar: :any,                 ventura:       "e92bc5bb321f6a26d57a3463f069192dc758a07e042dd7cc32e75983c596b468"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57a1604e22b1fa6069ba0f8295f317555ec44e3bc3192eb765beb10fae3cd685"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b244eb3ff5cb7d1cd678a647a3c45b32d2317c940e8d29e17ebd7931ccef94aa"
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