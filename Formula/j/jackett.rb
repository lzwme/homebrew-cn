class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2384.tar.gz"
  sha256 "0ebf060afee738aaa7ec4dd04693277854f999a824605ce4aad9a538d30be44d"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "28dd6629cf1c3acc55dd5f150ae7757447309a42cee73dcb6ba853fd8469bb93"
    sha256 cellar: :any,                 arm64_sonoma:  "bd97e4362ffda4f10a7aa84dd0cfa380c5c959f1f0fe07ac017246fa19ed5bb8"
    sha256 cellar: :any,                 arm64_ventura: "bc34aad3160f291a2d8062d3c375c150f315f8699e056e4cb4f65b22f434fa2e"
    sha256 cellar: :any,                 ventura:       "e0d8e7d21cc24d69407e79886b0428ebfa6d278cd7301712610081b22c80bb4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae26a81ff5047b0021c3ae233c0d9c63940c87a236c2d3f0d46536f1de1dd35f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86e88c7c26dd923b7191e52954870c1e440e2fc8139bce520faddb83ce0ab162"
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