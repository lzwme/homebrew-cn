class ArchiSteamFarm < Formula
  desc "Application for idling Steam cards from multiple accounts simultaneously"
  homepage "https://github.com/JustArchiNET/ArchiSteamFarm"
  url "https://github.com/JustArchiNET/ArchiSteamFarm.git",
      tag:      "6.2.0.5",
      revision: "02f505d9628c55a23ef321a481be57bc999cf5fa"
  license "Apache-2.0"
  head "https://github.com/JustArchiNET/ArchiSteamFarm.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f981efb4894ebb849e72b6cad6d39ddac5b259315f22a60dd79d106f2124ed9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1fa31666c516da5a714575429e5da299395f51443aa5f76b550856f42c58b6e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bf03e8e8850af3b7d0014c7f77db3ea5c5e89e855583b6781598f9eac4f766e4"
    sha256 cellar: :any_skip_relocation, ventura:       "42a3cbd3278fa05a1d1bfb1fbc4fd9b2a9430998c7c983611db89785258dcba6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44f658e99a5b7ee4d73b9382dc9a02410dd883a65676414de2b17f25508f903c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1fd9bd255f6165d69f88a8b8993db5221a1fd5d2e818407e55b22d5ad57313b"
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
      system "dotnet", "publish", plugin, *args, "--output", libexec/"plugins"/plugin
    end

    bin.install_symlink libexec/"ArchiSteamFarm" => "asf"
    etc.install libexec/"config" => "asf"
    rm_r(libexec/"config")
    libexec.install_symlink etc/"asf" => "config"
  end

  def caveats
    <<~EOS
      ASF config files should be placed under #{etc}/asf/.
    EOS
  end

  test do
    _, stdout, wait_thr = Open3.popen2("#{bin}/asf")
    assert_match version.to_s, stdout.gets("\n")
  ensure
    Process.kill("TERM", wait_thr.pid)
  end
end