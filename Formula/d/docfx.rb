class Docfx < Formula
  desc "Tools for building and publishing API documentation for .NET projects"
  homepage "https:dotnet.github.iodocfx"
  url "https:github.comdotnetdocfxarchiverefstagsv2.74.1.tar.gz"
  sha256 "c77254cc4f5cbac235b728a01fd9bf3c94161535ea063494d07aec877a78b361"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "57cf514074f7df6958bd672e8b90dc3956c8c3dfcef357bb9efaf0ffbe7b9402"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fba2895d1802dbca980bda887a91405b15c1f2350710ae1ac036d474e537e7f5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f90413b7c603f3ca4028e217efc606d814d7af2675a51a195c8290a499aca1cf"
    sha256 cellar: :any_skip_relocation, sonoma:         "db14d6add2ce0b4861cf1b89ace4befcf78e00115f68d81f1346c2c61239f4ac"
    sha256 cellar: :any_skip_relocation, ventura:        "d48302c96f06d61aa8eb0b44748f26a24d6e50327054260326bbedefc196abc9"
    sha256 cellar: :any_skip_relocation, monterey:       "0a8c3f54bdc31afa2df900893cfdea08431748afe09866956eb99118645ee2b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a08d7921aecd13b024576eb0e8a59e38ce81b68ff92816a464d3a2b07e318c75"
  end

  depends_on "dotnet"

  def install
    dotnet = Formula["dotnet"]
    os = OS.mac? ? "osx" : OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s

    # specify the target framework to only target the currently used version of
    # .NET, otherwise additional frameworks will be added due to this running
    # inside of GitHub Actions, for details see:
    # https:github.comdotnetdocfxblobmainDirectory.Build.props#L3-L5
    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --runtime #{os}-#{arch}
      --no-self-contained
      -p:Version=#{version}
      -p:TargetFrameworks=net#{dotnet.version.major_minor}
    ]

    system "dotnet", "publish", "srcdocfx", *args

    (bin"docfx").write_env_script libexec"docfx",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  test do
    system bin"docfx", "init", "--yes", "--output", testpath"docfx_project"
    assert_predicate testpath"docfx_projectdocfx.json", :exist?,
                     "Failed to generate project"
  end
end