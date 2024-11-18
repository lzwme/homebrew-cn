class ArchiSteamFarm < Formula
  desc "Application for idling Steam cards from multiple accounts simultaneously"
  homepage "https:github.comJustArchiNETArchiSteamFarm"
  license "Apache-2.0"
  head "https:github.comJustArchiNETArchiSteamFarm.git", branch: "main"

  stable do
    url "https:github.comJustArchiNETArchiSteamFarm.git",
        tag:      "6.0.8.7",
        revision: "6dddaa59926c1e48419e5d374deef8aa712ad610"

    # Backport support for .NET 9
    patch do
      url "https:github.comJustArchiNETArchiSteamFarmcommit1b626caa538605281c6a73cf8ab2b056bc771a39.patch?full_index=1"
      sha256 "03f45f93b018194abd7a00857156de5a4737ed10cf7b816f251fffbbe76975f8"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "960adeaff2e039c5c59e600bbbd996c1bf6d5b12594a2595989a55b3ccbdf8a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1db6b00c6a2fa5c3c7f953b5db7a9d7c1bb213a8ed266e6858e850b9c8690eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6d8fc4fd032faaff8b6172dd324ed30179d6bf003bf05b63deb2b5dff86e8278"
    sha256 cellar: :any_skip_relocation, ventura:       "c633fb38c5abf7af72a254306938c60a76a2b9b3aae00274c8dc85f40bdf74d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "035547ccccc53eaad19716b09a33b860d454c6f6326645709848a524f4338d54"
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