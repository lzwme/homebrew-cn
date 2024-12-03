class ArchiSteamFarm < Formula
  desc "Application for idling Steam cards from multiple accounts simultaneously"
  homepage "https:github.comJustArchiNETArchiSteamFarm"
  url "https:github.comJustArchiNETArchiSteamFarm.git",
      tag:      "6.1.0.2",
      revision: "90ead36184e8c310cef135a49769a2abbc675a56"
  license "Apache-2.0"
  head "https:github.comJustArchiNETArchiSteamFarm.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "890c743d007ec9b5f3bf94a8d20a1e2aebfa997f9953c3cb5a287f623df94150"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9eb44e5c87f5bf2db31c1455e4316980b104af8f9003020ad147d91c4b4ccb9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6683c839951e36e60ae02fff63be6179cb88bfd8cb142ced20dc604e36b87b78"
    sha256 cellar: :any_skip_relocation, ventura:       "cc56f8be243e9e91d0ec39ca924e823c672a71a623966e51ffe2c84286d8385d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1694d65a4daf30d536723368421a6108d6e53070c041125cff8bb6cd3b8f318"
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