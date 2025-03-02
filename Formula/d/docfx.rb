class Docfx < Formula
  desc "Tools for building and publishing API documentation for .NET projects"
  homepage "https:dotnet.github.iodocfx"
  url "https:github.comdotnetdocfxarchiverefstagsv2.78.3.tar.gz"
  sha256 "d97142ff71bd84e200e6d121f09f57d28379a0c9d12cb58f23badad22cc5c1b7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc0289068670e27af69eba93033c124d627aa4bb97143abe05f1c9d4ad6684da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ca94216d682bdd0a229071d1c72de96f2ddbe47f82e72d1e66eed970a24c394"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "36dcefda17bf44a0a09f883a6f32ef2e4cd21c17e15675b64e462e7957424a66"
    sha256 cellar: :any_skip_relocation, ventura:       "b03b64889ca251603291b374c0416464b895c47d73abed2f3e565eafa40c82dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb3af6fd91667aa0f5f693eb9513a2aefa3ac3b8c5d607bb2ebc4af364a5b958"
  end

  depends_on "dotnet"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"

    dotnet = Formula["dotnet"]

    # specify the target framework to only target the currently used version of
    # .NET, otherwise additional frameworks will be added due to this running
    # inside of GitHub Actions, for details see:
    # https:github.comdotnetdocfxblobmainDirectory.Build.props#L3-L5
    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --no-self-contained
      --use-current-runtime
      -p:Version=#{version}
      -p:TargetFrameworks=net#{dotnet.version.major_minor}
    ]

    system "dotnet", "publish", "srcdocfx", *args

    (bin"docfx").write_env_script libexec"docfx",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  test do
    system bin"docfx", "init", "--yes", "--output", testpath"docfx_project"
    assert_path_exists testpath"docfx_projectdocfx.json", "Failed to generate project"
  end
end