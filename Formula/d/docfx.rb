class Docfx < Formula
  desc "Tools for building and publishing API documentation for .NET projects"
  homepage "https://dotnet.github.io/docfx/"
  url "https://ghproxy.com/https://github.com/dotnet/docfx/archive/refs/tags/v2.74.0.tar.gz"
  sha256 "58920322987ce5b67e4a6dc33cc268cfd014c69b498ee139c42acdf473cca4df"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f41fd4209dd58268627c42da325324ddaed8cade498679bfcdf736deb42e0114"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0231f4fe92c4347dabb48ead4a88afe8dc9e22e1bdc81c293b448451a6ac04d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "234494e810d9ecd126bc962e3f745efb7cb004cba18385719df7cb26f3a6809f"
    sha256 cellar: :any_skip_relocation, ventura:        "b6d2423c9144ce68d55461508837f8319045769bdaeaa519efe820da3f2508ac"
    sha256 cellar: :any_skip_relocation, monterey:       "a4eb654264424aeba575f5c7dcadee50be17db7b8cdd16776cf13e57c94c8795"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "512a2c76b383c9711b7fa4963295118eea5a7befb689d84354d6210e85d032a9"
  end

  depends_on "dotnet"

  def install
    dotnet = Formula["dotnet"]
    os = OS.mac? ? "osx" : OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s

    # specify the target framework to only target the currently used version of
    # .NET, otherwise additional frameworks will be added due to this running
    # inside of GitHub Actions, for details see:
    # https://github.com/dotnet/docfx/blob/main/Directory.Build.props#L3-L5
    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --runtime #{os}-#{arch}
      --no-self-contained
      -p:Version=#{version}
      -p:TargetFrameworks=net#{dotnet.version.major_minor}
    ]

    system "dotnet", "publish", "src/docfx", *args

    (bin/"docfx").write_env_script libexec/"docfx",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  test do
    system bin/"docfx", "init", "--yes", "--output", testpath/"docfx_project"
    assert_predicate testpath/"docfx_project/docfx.json", :exist?,
                     "Failed to generate project"
  end
end