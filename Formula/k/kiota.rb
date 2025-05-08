class Kiota < Formula
  desc "OpenAPI based HTTP Client code generator"
  homepage "https:aka.mskiotadocs"
  url "https:github.commicrosoftkiotaarchiverefstagsv1.26.0.tar.gz"
  sha256 "0712d0161ae202e1908270f40796059557ef90e5637e9d62bdbcdb2edf6caf0d"
  license "MIT"
  head "https:github.commicrosoftkiota.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6d61e141396bc587f59cb3d7e98d2f44dbdcce7a2eff565bb2bca308d083578"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cbd891ee1058b47315f9f7e42c5ca59af94ac20177a53624fca5ea4ab605091c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4f4a0255170bb56fd218c3e406c12230a45c1abffd3a0cc1736d305da4e3a4aa"
    sha256 cellar: :any_skip_relocation, ventura:       "46ccb1700ea995273eeef20e84fee68263ac8333f9b730c537063881cc06a4f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "174bc3e465c1ce9974f3943a1a7bba61f5897f73dedd2fe454561679ed34e182"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c30f4bb5fb23c99aff8590089dfe461f66b4707dae158bbc2b3e94d450e22654"
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