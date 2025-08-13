class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2280.tar.gz"
  sha256 "682b6e009bf1cc23d82c628615a7febc95b7d00ceba25494b195e6d8bc08937a"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e56819808f55e11010f63d4daf7fbe6b3b194cd687b2ebf948bd3db9238cb181"
    sha256 cellar: :any,                 arm64_sonoma:  "2baa0a2866355aac5a2d4b231323f1217835f6841a0acd213c4b6f61bf454b29"
    sha256 cellar: :any,                 arm64_ventura: "621a547fbdcc662c6f624546ae3dc01de3d4691ed80052fb4acd3a9bf1283668"
    sha256 cellar: :any,                 ventura:       "19203d07831899a8b7a19d8e346655d707c610756505c73e4a9f04e6c9f1e6cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3974d9b5f72c4409247689064f7d6716e47f8c73a31ce608081b649d155de618"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64d294b8335a8cc2be57e801f1ba09180a598c696da7f14f1d489d998d3223e3"
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