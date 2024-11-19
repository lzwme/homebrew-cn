class Docfx < Formula
  desc "Tools for building and publishing API documentation for .NET projects"
  homepage "https:dotnet.github.iodocfx"
  url "https:github.comdotnetdocfxarchiverefstagsv2.78.0.tar.gz"
  sha256 "d4b2c80d2042ec81b85b9ae5dd026a6dde71c8029db3113d5a101d07dc078ccb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "855573d550a5f2c34d59fb49a075678326b23c3ae49816d1db2727da4406a075"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "620faab34ebdd849ec36d5a796ddb56e14815df5e44030990af321ea70868a4b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fc6108b87bcf053f572b87b741373901288fa52fd16f6f1a9e65a83769da2852"
    sha256 cellar: :any_skip_relocation, ventura:       "1d86bcb6083dd8da25f7eb7a872519c86ea2c1808cedd55f69b189bb36abb146"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e115c51f534956a337e9b96194e9735892046f8ab8f7e14db40ae6e3f2b58e81"
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