class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1199.tar.gz"
  sha256 "e3dfedfb25724751536922d957e64d74acd0eb237dca89c59c0a7b51709c70d7"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1122f21ee8b8222603afbd34582bed7e7d8ba96c2a830c81970193308867b55d"
    sha256 cellar: :any,                 arm64_sonoma:  "2f5b89032bce3cea6ae1215bef69853ce6ef95dffebe71fa1ea3ef23ae321e1b"
    sha256 cellar: :any,                 arm64_ventura: "5557e4aaa5b6fab3e1b6693d425fc0afa23b61b15be65ab61051893722b91452"
    sha256 cellar: :any,                 ventura:       "01df9e66bb60583e55ae8c7e1dc2073857ce0fa65555af98819695ed55b61c68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aacdca97a4e860871807be7ece751ab8149856575362d392416473780309e247"
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