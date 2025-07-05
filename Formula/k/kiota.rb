class Kiota < Formula
  desc "OpenAPI based HTTP Client code generator"
  homepage "https://aka.ms/kiota/docs"
  url "https://ghfast.top/https://github.com/microsoft/kiota/archive/refs/tags/v1.27.0.tar.gz"
  sha256 "cbd29d5ac7a581ad845fac6eb19591bdcf4306b698fc399b5ff4e2e4083699b4"
  license "MIT"
  head "https://github.com/microsoft/kiota.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "794871f9fda5727c8e04aefc1c2fef80ddf7df0ebf263bb2b7dd77a45ba537d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92d8c8fa5db598aefc277745d5526d410e39805327c728eaf59540cea28a601a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e56fbc1b4a72faed51000a1f0bcef21362af840ace083ebb1707a67cd45dfe7d"
    sha256 cellar: :any_skip_relocation, ventura:       "9784aa7f7265bafd78888a7828025e5af44d67deb4486e855dbd3af773c9d456"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3119dfbdaedcd920d887d31428351b001c3e2545c133d8c2e8dba499b60805d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ea3bd3aaecd7f2d77b5473b16b03aecdd1f886c8c890183adcefad39e76040f"
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

    system "dotnet", "publish", "src/kiota/kiota.csproj", *args
    (bin/"kiota").write_env_script libexec/"kiota", DOTNET_ROOT: dotnet.opt_libexec
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kiota --version")

    info_output = shell_output("#{bin}/kiota info")
    assert_match "Go          Stable", info_output
    assert_match "Python      Stable", info_output

    search_output = shell_output("#{bin}/kiota search github")
    assert_match "apisguru::github.com                            GitHub v3 REST API", search_output
  end
end