class ArchiSteamFarm < Formula
  desc "Application for idling Steam cards from multiple accounts simultaneously"
  homepage "https:github.comJustArchiNETArchiSteamFarm"
  url "https:github.comJustArchiNETArchiSteamFarm.git",
      tag:      "6.1.3.3",
      revision: "e5c9defac847c173694b1f523ba5ef996447501a"
  license "Apache-2.0"
  head "https:github.comJustArchiNETArchiSteamFarm.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e8873bee48d092754165be209f94056638c5bf98bc4b8d4a0a74ddbc7972fc6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1029105fe9bc3fc89b49bd03c3ac726c14d6668d3a0b5b0842a1df35a20ebb4e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6604c05a0a33fad8fc11282bf45ab2b03e5a6331769cb78692cd47507a26fa70"
    sha256 cellar: :any_skip_relocation, ventura:       "f01f02e7c5028b88f1fcd1dbf1f59814d023aa341fcaa0665b9575c953348396"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dfee35a76f4605fc57fe51373090e69b9cb0d74e69b13420766cf171e2fd7441"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4d8f32ba2dadc785c1faa343a3befd8e8dd42d1fe1ca9ea5e9470964dd3e042"
  end

  depends_on "node" => :build
  depends_on "dotnet"

  def install
    plugins = %w[
      ArchiSteamFarm.OfficialPlugins.ItemsMatcher
      ArchiSteamFarm.OfficialPlugins.MobileAuthenticator
    ]

    dotnet = Formula["dotnet"]
    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --no-self-contained
      --use-current-runtime
    ]
    asf_args = %W[
      --output #{libexec}
      -p:AppHostRelativeDotNet=#{dotnet.opt_libexec.relative_path_from(libexec)}
      -p:PublishSingleFile=true
    ]

    system "npm", "ci", "--no-progress", "--prefix", "ASF-ui"
    system "npm", "run-script", "deploy", "--no-progress", "--prefix", "ASF-ui"

    system "dotnet", "publish", "ArchiSteamFarm", *args, *asf_args
    plugins.each do |plugin|
      system "dotnet", "publish", plugin, *args, "--output", libexec"plugins"plugin
    end

    bin.install_symlink libexec"ArchiSteamFarm" => "asf"
    etc.install libexec"config" => "asf"
    rm_r(libexec"config")
    libexec.install_symlink etc"asf" => "config"
  end

  def caveats
    <<~EOS
      ASF config files should be placed under #{etc}asf.
    EOS
  end

  test do
    _, stdout, wait_thr = Open3.popen2("#{bin}asf")
    assert_match version.to_s, stdout.gets("\n")
  ensure
    Process.kill("TERM", wait_thr.pid)
  end
end