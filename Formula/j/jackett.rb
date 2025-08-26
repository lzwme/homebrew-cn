class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2343.tar.gz"
  sha256 "a5e85eef082faf1f5c5b3ef35bf46e03f1916907b2833fd15693c3fd36353d60"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a3ba7dd1673decea8f1c455f373a4c13a285435a5c91691e3afc0908d48e090a"
    sha256 cellar: :any,                 arm64_sonoma:  "81f5f4ce5e1c404abd0c5657938d3349a4c5a0ddff52346598b322f2c366f6e3"
    sha256 cellar: :any,                 arm64_ventura: "a65beabd6da3e09ba259cbbbc19112e28e66dc3dfbf69b4f6e6058a2f2eae3d6"
    sha256 cellar: :any,                 ventura:       "65da0a9bff41be556926e36194d10210af65ca8d14e1a770ef7588636bc193cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc5d20a7bb90bfbe3ce12dd90c2939afaedfbc989adc3c76b2f73463c47d492e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6bfd608a47a1eae90fe0092128fd88ff616e0db3bc268aaa53a5c298ccbfaa2"
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