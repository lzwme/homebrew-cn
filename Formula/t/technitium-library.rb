class TechnitiumLibrary < Formula
  desc "Library for technitium .net based applications"
  homepage "https://technitium.com"
  url "https://ghfast.top/https://github.com/TechnitiumSoftware/TechnitiumLibrary/archive/refs/tags/dns-server-v15.6.1.tar.gz"
  sha256 "981c54a68007f4d7c6e4af09faf8eb8cfe613dd4760ab5daebd504756fb7f4f1"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "28303bac8695be3d0dc6c9978601fb84554912e6c7834a21b49cbf4cbd97d5a4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ed342d376fe90c3790e6254c0e7d96dcf3605467093e2b172eec672e4a4d32f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1885b221495f99dc590e78f635920753db8fa201462e8e7f709523c48c01fbff"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ea3f414f135a6a370f49d2bae0e98b6b31bb95af04a19a8e0853dccbd03f0a83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "66d7bb370ed897befbb26129a739ddb6e95e21d3d8a0fcf5f9dad76f4b7cf5ec"
  end

  depends_on "dotnet"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"

    dotnet = Formula["dotnet"]
    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --no-self-contained
      --output #{libexec}
      --use-current-runtime
    ]

    system "dotnet", "publish", "TechnitiumLibrary.ByteTree/TechnitiumLibrary.ByteTree.csproj", *args
    system "dotnet", "publish", "TechnitiumLibrary.Net/TechnitiumLibrary.Net.csproj", *args
    system "dotnet", "publish", "TechnitiumLibrary.Security.OTP/TechnitiumLibrary.Security.OTP.csproj", *args
  end

  test do
    dotnet = Formula["dotnet"]
    target_framework = "net#{dotnet.version.major_minor}"

    (testpath/"test.cs").write <<~CSHARP
      using System;
      using TechnitiumLibrary;

      namespace Homebrew
      {
        public class TechnitiumLibraryTest
        {
          public static void Main(string[] args)
          {
            Console.WriteLine(Base32.ToBase32HexString(new byte[] { 1, 2, 3 }));
          }
        }
      }
    CSHARP

    (testpath/"test.csproj").write <<~XML
      <Project Sdk="Microsoft.NET.Sdk">
        <PropertyGroup>
          <OutputType>Exe</OutputType>
          <TargetFrameworks>#{target_framework}</TargetFrameworks>
          <PlatformTarget>AnyCPU</PlatformTarget>
          <RootNamespace>Homebrew</RootNamespace>
          <PackageId>Homebrew.Dotnet</PackageId>
          <Title>Homebrew.Dotnet</Title>
          <Product>$(AssemblyName)</Product>
          <EnableDefaultCompileItems>false</EnableDefaultCompileItems>
        </PropertyGroup>
        <ItemGroup>
          <Compile Include="test.cs" />
        </ItemGroup>
        <ItemGroup>
          <Reference Include="TechnitiumLibrary">
            <HintPath>#{libexec}/TechnitiumLibrary.dll</HintPath>
          </Reference>
        </ItemGroup>
      </Project>
    XML

    system "#{dotnet.opt_libexec}/dotnet", "build", "--framework", target_framework,
           "--output", testpath, testpath/"test.csproj"
    output = shell_output("#{dotnet.opt_libexec}/dotnet run --framework #{target_framework} #{testpath}/test.dll")
    assert_match "04106===", output
  end
end