class Kiota < Formula
  desc "OpenAPI based HTTP Client code generator"
  homepage "https://aka.ms/kiota/docs"
  url "https://ghfast.top/https://github.com/microsoft/kiota/archive/refs/tags/v1.32.1.tar.gz"
  sha256 "9c854867858cb448ff6a4fd133b2b19cec0a32774ca2007eea050a3c609c219a"
  license "MIT"
  head "https://github.com/microsoft/kiota.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0c02c3fdd42a247b3ac84ec0d92bee1c45c6a366dd32ea370e8dce51539fc3fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "311c73089a02bb8750e96637739562a3a3077d3b4351c669e679d1b939f9c8c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e019b984a6d861599840a46a676f092ee7a52c404963c65b9900eab2ef9ebdb1"
    sha256 cellar: :any_skip_relocation, sonoma:        "3aa1536672a4e960fc59c74d3fa3193ba25e2b8f3ad15cb6c381d51adb7a6801"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da68e2129b5f7d39bdb6864be029a3011178db9f97b7e31be1719a4160b6a4ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3efe99a2975554cba0b670ee7ea58c3f0ebcaf30b6533a3ee342a1addcc6c2a5"
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