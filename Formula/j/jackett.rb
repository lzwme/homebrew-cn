class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1641.tar.gz"
  sha256 "e5b320171a120c587d55c2b4aa9304881822309457b35b8cfb6691bc323da7c4"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "20e1d325d480286b3ed79886a85bca597692f43809c0c48899e6f1f291716df5"
    sha256 cellar: :any,                 arm64_sequoia: "511e26d94392976e23c744ef645859a0f6f4d5c679a2dfae4e8a298bb6fbd1d8"
    sha256 cellar: :any,                 arm64_sonoma:  "3be823e4d70eb72e277b041ea902b3ac78e45ce1f0b6cde2ac9fa5d05d6d6e8e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc2f4a2e264d8e5aefa3766accc54b274e197b859068dae66ec8b46048290971"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89610e4577c888b612273a7e0f8433fdadd136b5e4296f8f6c22d48715c85e2a"
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