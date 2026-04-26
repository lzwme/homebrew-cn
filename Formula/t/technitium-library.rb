class TechnitiumLibrary < Formula
  desc "Library for technitium .net based applications"
  homepage "https://technitium.com"
  url "https://ghfast.top/https://github.com/TechnitiumSoftware/TechnitiumLibrary/archive/refs/tags/dns-server-v15.0.0.tar.gz"
  sha256 "39e3e17e4f9b100f7ee7fdd7ce9bb0849708794d8e43061f41bec063257dced5"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d05155319de8aa208db4bbc283f278113bec91022d4689a4fb40101bcfe299d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "901b220b40ad96ddfa404f53aaaa300ee90460ac92573b90662b89ab7b4a396a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66fb816fcc954c91c34295f946d2f99e90a0c8002049be3760b7ed664498d0e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "94571472b5fee9033ea3d575a9673cadea56ac63bca68eaf08d65c4a090bb516"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9bee55d962057816c5dee0951872a7fb217def3242d6bec47c5136ac4b6d3d76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b47a6f376f0fa214d72ba442465ac41d0f7282d4a5b1e4bffd2b54c7633514c2"
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