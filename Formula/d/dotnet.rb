class Dotnet < Formula
  desc ".NET Core"
  homepage "https://dotnet.microsoft.com/"
  # Source-build tag announced at https://github.com/dotnet/source-build/discussions
  url "https://github.com/dotnet/dotnet.git",
      tag:      "v8.0.0",
      revision: "40e7f014ff784457efffa58074549735e30772ae"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3e7c2a22ccd3eb9780607ea77bc0a82c772411a093268973e831393fb9cb9df1"
    sha256 cellar: :any,                 arm64_ventura:  "1452fc9a89d69d27d49cc67304abbf72df107cba7dab2d4c1806dfd628c58017"
    sha256 cellar: :any,                 arm64_monterey: "952a520c7b0f1b117c0d0c67503209a555519722078f4e06a47265d0dbfe27c6"
    sha256 cellar: :any,                 ventura:        "f5b5308c1f61266fef07a72191310874614be0ac66f963eda8f2c39925f4aef5"
    sha256 cellar: :any,                 monterey:       "758df6ba1fbeab7227b3cc07f1a147d8b1f62070c8dd32a570ae6a640bd54f18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7081e687c5ebad93ba573a75022979de54cf5ddc801ea140072d6a8c1d13e7b6"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build
  depends_on "icu4c"
  depends_on "openssl@3"

  uses_from_macos "llvm" => :build
  uses_from_macos "krb5"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libunwind"
    depends_on "lttng-ust"
  end

  # Upstream only directly supports and tests llvm/clang builds.
  # GCC builds have limited support via community.
  fails_with :gcc

  def install
    if OS.mac?
      # Deparallelize to avoid missing PDBs
      ENV.deparallelize

      # Disable crossgen2 optimization in ASP.NET Core to work around build failure trying to find tool.
      # Microsoft.AspNetCore.App.Runtime.csproj(445,5): error : Could not find crossgen2 tools/crossgen2
      # TODO: Try to remove in future .NET 8 release or when macOS is officially supported in .NET 9
      inreplace "src/aspnetcore/src/Framework/App.Runtime/src/Microsoft.AspNetCore.App.Runtime.csproj",
                "<CrossgenOutput Condition=\" '$(TargetArchitecture)' == 's390x'",
                "<CrossgenOutput Condition=\" '$(TargetOsName)' == 'osx'"
    else
      ENV.append_path "LD_LIBRARY_PATH", Formula["icu4c"].opt_lib
      ENV.append_to_cflags "-I#{Formula["krb5"].opt_include}"

      # Use our libunwind rather than the bundled one.
      inreplace "src/runtime/eng/SourceBuild.props",
                "--outputrid $(TargetRid)",
                "\\0 --cmakeargs -DCLR_CMAKE_USE_SYSTEM_LIBUNWIND=ON"

      # Work around build script getting stuck when running shutdown command on Linux
      # TODO: Try removing in the next release
      # Ref: https://github.com/dotnet/source-build/discussions/3105#discussioncomment-4373142
      inreplace "build.sh", '"$CLI_ROOT/dotnet" build-server shutdown', ""
      inreplace "repo-projects/Directory.Build.targets",
                '<Exec Command="$(DotnetToolCommand) build-server shutdown" />',
                ""
    end

    system "./prep.sh"
    # We unset "CI" environment variable to work around aspire build failure
    # error MSB4057: The target "GitInfo" does not exist in the project.
    # Ref: https://github.com/Homebrew/homebrew-core/pull/154584#issuecomment-1815575483
    with_env(CI: nil) do
      system "./build.sh", "--clean-while-building", "--online"
    end

    libexec.mkpath
    tarball = Dir["artifacts/*/Release/dotnet-sdk-*.tar.gz"].first
    system "tar", "-xzf", tarball, "--directory", libexec
    doc.install Dir[libexec/"*.txt"]
    (bin/"dotnet").write_env_script libexec/"dotnet", DOTNET_ROOT: libexec

    bash_completion.install "src/sdk/scripts/register-completions.bash" => "dotnet"
    zsh_completion.install "src/sdk/scripts/register-completions.zsh" => "_dotnet"
    man1.install Dir["src/sdk/documentation/manpages/sdk/*.1"]
    man7.install Dir["src/sdk/documentation/manpages/sdk/*.7"]
  end

  def caveats
    <<~EOS
      For other software to find dotnet you may need to set:
        export DOTNET_ROOT="#{opt_libexec}"
    EOS
  end

  test do
    target_framework = "net#{version.major_minor}"
    (testpath/"test.cs").write <<~EOS
      using System;

      namespace Homebrew
      {
        public class Dotnet
        {
          public static void Main(string[] args)
          {
            var joined = String.Join(",", args);
            Console.WriteLine(joined);
          }
        }
      }
    EOS
    (testpath/"test.csproj").write <<~EOS
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
      </Project>
    EOS
    system bin/"dotnet", "build", "--framework", target_framework, "--output", testpath, testpath/"test.csproj"
    assert_equal "#{testpath}/test.dll,a,b,c\n",
                 shell_output("#{bin}/dotnet run --framework #{target_framework} #{testpath}/test.dll a b c")
  end
end