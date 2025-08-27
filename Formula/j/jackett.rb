class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2349.tar.gz"
  sha256 "7cc6a5743da80fb7a66542d4092331443de7e74a1bcebf2758e1323e6819db4a"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0e9e1c7101a12056a44d2e8b10ad3b0fa8f5c7cf734b4c30ad9d991af55688ee"
    sha256 cellar: :any,                 arm64_sonoma:  "755c736f14ca892fdcfb3c0d36f5474021ecafd8b5f951968492cd1e7804eaa9"
    sha256 cellar: :any,                 arm64_ventura: "2b035bbe3a91c421ad8fc2de03163333145fc6406b3a25a369f5caf07b5644ca"
    sha256 cellar: :any,                 ventura:       "102042afd956624f3d414718b2ca3a3109ebb5c46e46e8fe7d1d0c8dd8f9451a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27c3fed82aa27cdd2a79275631a7056ff82d8d8ae0555d23be00b13ee70673d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7f2d6828a0a4e4142a8062034d12ae8e74f4879e263d70813d1cc1b8406bcfb"
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