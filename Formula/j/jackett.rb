class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1177.tar.gz"
  sha256 "7c1ae748e0a12fc14e77ddc11ffae6d8e090dbbd87c9114ff285369d1b2decc8"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0f69797a9ebb993383f3ad889e867f33637f81c77b5f16a60639a19f15fe9e82"
    sha256 cellar: :any,                 arm64_sonoma:  "e7af6aa501fd1d625e24b51954763ab60cb191e37d032c5e239902752dce20d9"
    sha256 cellar: :any,                 arm64_ventura: "2ac08e9c7695ff0d96a1de7b481e8980a9ea6eb99f9f8c174ca100673c605872"
    sha256 cellar: :any,                 ventura:       "54f02db8882efd9b34fe2018f698a13ad09f76e889e09405780b36ea9ae7932c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed4f1eefcaa712ff2c2789c3887bcc2819c1e0c757d5a60941454caee64415c8"
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