class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.2035.tar.gz"
  sha256 "f388e81def14a3314b8e883b89a969a320d3bc274b3a51b88c1c3794a6f4cf49"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4ef6366ae7763c838295ffd8cc039b497cc098e356478c20aa84493a0c4b0383"
    sha256 cellar: :any,                 arm64_sonoma:  "f9521d34678b3a7836f1eef8e9fdd50d6eeada9727d799e3b5c37d19e4d7e20f"
    sha256 cellar: :any,                 arm64_ventura: "8f3d243d16b05ca7929aea1303764649cabe086c273c6e945673a84a908e555b"
    sha256 cellar: :any,                 ventura:       "7449b49513adfda910238f18ee27284cca524d584f5298950c847dcee8fbddcb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57f94877cb7c88969f640d7c95adf7e666b564d130bb27d2aa274cc8fdd41741"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5173692f7c2a90366431ebdbb74556dec6cb7d7489508916063326f1057a2a62"
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
        p:AssemblyVersion=#{version}
        p:FileVersion=#{version}
        p:InformationalVersion=#{version}
        p:Version=#{version}
      ]
    end

    system "dotnet", "publish", "srcJackett.Server", *args

    (bin"jackett").write_env_script libexec"jackett", "--NoUpdates",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  service do
    run opt_bin"jackett"
    keep_alive true
    working_dir opt_libexec
    log_path var"logjackett.log"
    error_log_path var"logjackett.log"
  end

  test do
    assert_match(^Jackett v#{Regexp.escape(version)}$, shell_output("#{bin}jackett --version 2>&1; true"))

    port = free_port

    pid = fork do
      exec bin"jackett", "-d", testpath, "-p", port.to_s
    end

    begin
      sleep 15
      assert_match "<title>Jackett<title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http:localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end