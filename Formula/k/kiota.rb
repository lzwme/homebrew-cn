class Kiota < Formula
  desc "OpenAPI based HTTP Client code generator"
  homepage "https:aka.mskiotadocs"
  url "https:github.commicrosoftkiotaarchiverefstagsv1.24.3.tar.gz"
  sha256 "96a2102a55bd57f84c7e76b9617f57f9b5a908fbe95018664844e6e6d60961fa"
  license "MIT"
  head "https:github.commicrosoftkiota.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "afcbf142db49e959a8069f8949424c162ca4fdac937b4f473fe01480df5c6736"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc1cd07333184193f4552be4bd07fc3a704eb4ab02dbfb33877fa2c33a3de42f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c9e8fa8af5b188a2a102569ce7aa2bfcd5acc40b0f5e13eeea4a4875e5afe46f"
    sha256 cellar: :any_skip_relocation, ventura:       "23522e5bb5e5bc07c60e0bdb00fd295c3584549b7d08be472f116ecb8131c721"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90bb6fbc1bfdee27c6e08876d4314dcaa7c3d2132cbbce72b715f3fd7163c24a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f01a7a52bc6caa34abe135125a8afa62f755b746108903d980e3584897f7c69a"
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