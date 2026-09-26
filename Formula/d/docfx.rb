class Docfx < Formula
  desc "Tools for building and publishing API documentation for .NET projects"
  homepage "https://dotnet.github.io/docfx/"
  url "https://ghfast.top/https://github.com/dotnet/docfx/archive/refs/tags/v2.81.0.tar.gz"
  sha256 "55b492cab70a7f883ea5e9a7a134a23d25d70e97153b61d1083ad6b5fa6e2d68"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b6c411f22dfebd4d5b180413a10e43fcff245941a650bda443bfcaf2e3af8044"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "818ce54b7758e28c16b2a2dc253ba330c03255c6b80c1a6431fb7479aa6e6a5e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9b313b54dac0708b74c7a36806159e3379926022a6b1cca45ac45fd09bbe93dd"
    sha256 cellar: :any,                 arm64_linux:       "6a5d6998cd03ca39fcd555e7b1b21aaf41701b999baba3f4e4e4f06bbac5ab93"
    sha256 cellar: :any,                 x86_64_linux:      "929ae6b515af388a34b2d66305e4a27486ba6809dc6c311b535712381a41ceb4"
  end

  depends_on "node" => :build
  depends_on "dotnet"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"

    dotnet = Formula["dotnet"]

    # specify the target framework to only target the currently used version of
    # .NET, otherwise additional frameworks will be added due to this running
    # inside of GitHub Actions, for details see:
    # https://github.com/dotnet/docfx/blob/main/Directory.Build.props#L3-L5
    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --no-self-contained
      --use-current-runtime
      -p:Version=#{version}
      -p:TargetFrameworks=net#{dotnet.version.major_minor}
    ]

    cd "templates" do
      system "npm", "install", *std_npm_args(prefix: false)
      system "npm", "run", "build"
    end
    system "dotnet", "publish", "src/docfx", *args

    (bin/"docfx").write_env_script libexec/"docfx",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  test do
    # The sandbox denies FSEvents, so .NET's config file watcher would hang
    ENV["DOTNET_USE_POLLING_FILE_WATCHER"] = "1" if OS.mac?

    system bin/"docfx", "init", "--yes", "--output", testpath/"docfx_project"
    assert_path_exists testpath/"docfx_project/docfx.json", "Failed to generate project"
    assert_match "modern", shell_output("#{bin}/docfx template list")
  end
end