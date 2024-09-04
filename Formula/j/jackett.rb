class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.554.tar.gz"
  sha256 "2f780fd236ccb779b74e9d8d8464845ef091dfd370b9835f3f462fec74aa8b99"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6894a8caf29446c58651dfec0c48377ec1ba94f2d8c01ec0cee258b6cf1dcc3f"
    sha256 cellar: :any,                 arm64_ventura:  "cc1c98b616eabb05c725144bac3e9ce3bef6edd1605ee04412d023bb6ea6e587"
    sha256 cellar: :any,                 arm64_monterey: "3b41e7e9913e852de93d306cac8dbb4b3677775865d2103b1cd598fe68b81be8"
    sha256 cellar: :any,                 sonoma:         "c52209815310ee6c3168225eaf3b3627ac1dc36b9bb43ca078ea56d3eaece5cb"
    sha256 cellar: :any,                 ventura:        "f2ee3edd80c14b8043b691265a0c2b1c61550e69030bb4b9ebd522826c8454f2"
    sha256 cellar: :any,                 monterey:       "0744a392eb6eaca47b9f6c2e7ba4d3d2b7f2b3cce9ba12d837be355fb3a5c259"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4b6800efa249d4149d55d471faa8d6eedb9e64954df2f6758fc107429494bb2"
  end

  depends_on "dotnet"

  def install
    dotnet = Formula["dotnet"]
    os = OS.mac? ? "osx" : OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --runtime #{os}-#{arch}
      --no-self-contained
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