class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.402.tar.gz"
  sha256 "baef28392e2293b7e5f1d1ea58ecf548e2f3dc9d1e0355fcf157ed9ed4f96da7"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c79b2882bfac46d3ae3cbbac4001dd243d1e2b46b122ba127dc0d9c9039272f0"
    sha256 cellar: :any,                 arm64_sequoia: "f93f78f9b48b15d5fe71bcddf5258c63b691454bbd88fabc727b7c5e896be1c5"
    sha256 cellar: :any,                 arm64_sonoma:  "b00a196bc64b403a315227665786c24dce19708e4486977b802f4c0826cb554c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75f3c94dfa40702cf5a8946e9ff922faeb5dea41b99b46997e47962876ea9db6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5022952c16d8639637a912e3d36f8f47a5ab035c9751377f8c3a53cf0fb6ac1"
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