class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1261.tar.gz"
  sha256 "1455573e356599472d416df439b183380fbfd60aff2762ff759170b65367183f"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2e4cf9bfe19040483154ae79a9d2a20e3ee119f5501c6a8b9788d588878ccb64"
    sha256 cellar: :any,                 arm64_sonoma:  "3dccc862752cba466325cd11e590053fe915903db41185903054a7c2000c0215"
    sha256 cellar: :any,                 arm64_ventura: "f1217689a234c4017f0c6c0c599bceac28c101ee86918c85ce18bebbb371f0b7"
    sha256 cellar: :any,                 ventura:       "e2623834715c80b3e80b93820ae55453c4d61b639da7c5ccb79e1da910d74a7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58426e071d309cc1fb337e6e7f32aad5a8c7f8f706fcbc664780986686be6c29"
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