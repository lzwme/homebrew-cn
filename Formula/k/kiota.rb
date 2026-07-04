class Kiota < Formula
  desc "OpenAPI based HTTP Client code generator"
  homepage "https://aka.ms/kiota/docs"
  url "https://ghfast.top/https://github.com/microsoft/kiota/archive/refs/tags/v1.32.5.tar.gz"
  sha256 "ab1ffec21c9abae686c0bd0d78177834b539752eb454f9d7c67291dc2f8c1d5d"
  license "MIT"
  head "https://github.com/microsoft/kiota.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b4139a63b84f05fc7072b3e6f5230d29464d89c6641df1993b6f524c80ba5260"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea15809948684b9f97521f5e628343038e2b326555ed95b7b1ce0ea2f40440cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea7a9635bf6192000b6a4ccf04c0fb46d932634d6d3b3b2bd631beb6cf2b760d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8a51533849a10787cdddf28839a5a170f164dfc2aab23254dbfebcda70d08e2"
    sha256 cellar: :any,                 arm64_linux:   "94f78d614d5fc0f2aad9c8b8259435b4c8e648a9533817e56525deac17265378"
    sha256 cellar: :any,                 x86_64_linux:  "13f651d154db18b6ac5acea1b44d05aea42987333b0b575065f0cff31b2bc3db"
  end

  depends_on "dotnet"

  def install
    # Ignore dotnet version specification and use homebrew one
    rm "global.json"

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
    assert_match "Go         Stable", info_output
    assert_match "Python     Stable", info_output

    search_output = shell_output("#{bin}/kiota search github")
    assert_match(/apisguru::github.com\s+GitHub v3 REST API/, search_output)
  end
end