class Kiota < Formula
  desc "OpenAPI based HTTP Client code generator"
  homepage "https://aka.ms/kiota/docs"
  url "https://ghfast.top/https://github.com/microsoft/kiota/archive/refs/tags/v1.36.0.tar.gz"
  sha256 "270d166792183bb97dbc4a61fcb1d9bfbf790ea7190356097d27b99da3e28747"
  license "MIT"
  head "https://github.com/microsoft/kiota.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8e2f42fda752e101696d481cd29143b25a2c0f58f1de8503a934bf2d11208a12"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "74cbec6eac179ab82daf99050ddbe0fa46a2db34d754bb217913ca3d043d3974"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "caef875dd30f31b2fc2b140ef4f6f37885965a5d87575bdee35674a395987881"
    sha256 cellar: :any,                 arm64_linux:       "862ae3b875bcd0df3f85e38b17b059b2295c9e6184ebf6311b4d1c0d8e7d2f97"
    sha256 cellar: :any,                 x86_64_linux:      "5ac620a9843b4ee355752c8d730dd0594c0693f3ccd4620ee5c934043998fec7"
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
    # The sandbox denies FSEvents, so .NET's config file watcher would hang
    ENV["DOTNET_USE_POLLING_FILE_WATCHER"] = "1" if OS.mac?

    assert_match version.to_s, shell_output("#{bin}/kiota --version")

    info_output = shell_output("#{bin}/kiota info")
    assert_match "Go         Stable", info_output
    assert_match "Python     Stable", info_output

    search_output = shell_output("#{bin}/kiota search github")
    assert_match(/apisguru::github.com\s+GitHub v3 REST API/, search_output)
  end
end