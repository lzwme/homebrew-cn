class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1971.tar.gz"
  sha256 "4d4fd1f3097dbd65c3713ec6fbf88b87144edf811f53dec3445e81c51041d965"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0957e13f2f060ad1ed721cd15129a79ad2d6e9e432a90969c6cd6b23dc6d4df8"
    sha256 cellar: :any,                 arm64_sonoma:  "1172c9a92ccc6bf6dba01560f1fcb7d7978269055e66363124fa99f244d5681e"
    sha256 cellar: :any,                 arm64_ventura: "e02b1d0799645b77984cf77464e163c7e9de835bc267e6d60c4ed77e1324571b"
    sha256 cellar: :any,                 ventura:       "ab4437a4d27886d4e76bb4f8abff9b6a7444a0f4f7c504556c44e7140e2ba993"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "73b21f3201ecf714456bad7dbf599eac24896e0257c29d4f9605b8a38882caeb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca0954df5c1201970fb379d4c08a8e1eaf0ef4e3a360b7d2f99a540b60fe6195"
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