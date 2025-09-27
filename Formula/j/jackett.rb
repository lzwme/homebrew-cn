class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.23.69.tar.gz"
  sha256 "0416c72f17bbb3778f72aefbe4b76fc4231c9ae4197a2f6f4e31a1c4c199eb60"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5e406ac489314e9fe35d82d9432579495d79686e240f272fc2b1b55666cb8047"
    sha256 cellar: :any,                 arm64_sequoia: "140a9a6876e06b0d73cebf67fe218e94af57ddd1700f0400535aea988815f72c"
    sha256 cellar: :any,                 arm64_sonoma:  "5aa59ba37f1018650fb3844cda1fd4693c7e678129d12ac77ba13b975d49b1f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7b49a85db86ff88a72428a6e2bab5ae286262539c4d052d707032a9aa79838c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5145068b01923e7edc2b6e8f304cfc8e78497de15bd8878371f19b4df6c3a461"
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