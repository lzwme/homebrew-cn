class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1857.tar.gz"
  sha256 "74eabf8f6f7e1b459b55556ab7d45a9096fa8e227082a8f8d72602902bb1b40a"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ce822a4ef5cd1c8e3ac4f0a20a68208b36f08f4b6c3478a89d1bc8d25a3452ee"
    sha256 cellar: :any,                 arm64_sonoma:  "427c55385691337e18ace34e82b8784da5e9c49b5f75304800fc64782761595d"
    sha256 cellar: :any,                 arm64_ventura: "3ca178efcbf34eaad8eba5bbc2e9da38c9b69f7da7ebf3d635162cdb7bb0b3fc"
    sha256 cellar: :any,                 ventura:       "607427ecafdff7c5f672a761f06c99b3ed247d96b6f609febe6eca21351153e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6ab5e3b3a395557ba2e8455342009fd2758ff0c466462d8d26343217962e3ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c64ec7d2adf2507f36261421cdf8030a43865f3ec2b879f08a284213523bd1f"
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