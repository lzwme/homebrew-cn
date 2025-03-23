class Kiota < Formula
  desc "OpenAPI based HTTP Client code generator"
  homepage "https:aka.mskiotadocs"
  url "https:github.commicrosoftkiotaarchiverefstagsv1.24.1.tar.gz"
  sha256 "187503e751db91f1519c8e1351815d0292212e572e4af6ef45807afa6ee5d688"
  license "MIT"
  head "https:github.commicrosoftkiota.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd4a7d7831db09203c2a952c37ae86b5c492478f80bdb9be503ef5eaed25e1d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03682b91acaee392899690a7137009b191c0803424e0e65ac32f1218da3df085"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7df99fb9a7615826fdd8aa344bc58c51aef757ede65b1fdd88cbc4b278d5177b"
    sha256 cellar: :any_skip_relocation, ventura:       "f50670ea1752378916e90c2fbd3a5836cf3857da99ab3f0e3a4112976476599b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3418b8b11f1bbe536872515587bd2654ac84cbe81f3212a0cdf08cdaae0ca00b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec3ee595eaa9ea10d69e446504c362551980516874c9a58d571493138abae6ad"
  end

  depends_on "dotnet"

  def install
    dotnet = Formula["dotnet"]

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --no-self-contained
      --use-current-runtime
      -p:TargetFramework=net#{dotnet.version.major_minor}
      -p:PublishSingleFile=true
    ]
    args << "-p:Version=#{version}" if build.stable?

    system "dotnet", "publish", "srckiotakiota.csproj", *args
    (bin"kiota").write_env_script libexec"kiota", DOTNET_ROOT: dotnet.opt_libexec
  end

  test do
    assert_match version.to_s, shell_output("#{bin}kiota --version")

    info_output = shell_output("#{bin}kiota info")
    assert_match "Go          Stable", info_output
    assert_match "Python      Stable", info_output

    search_output = shell_output("#{bin}kiota search github")
    assert_match "apisguru::github.com                            GitHub v3 REST API", search_output
  end
end