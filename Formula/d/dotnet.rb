class Dotnet < Formula
  desc ".NET Core"
  homepage "https:dotnet.microsoft.com"
  # Source-build tag announced at https:github.comdotnetsource-builddiscussions
  url "https:github.comdotnetdotnet.git",
      tag:      "v8.0.3",
      revision: "49a39629323839c28481dd42545ce44d11c75c5a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0a39429e6aedea2ee05900f02b86caa61bbecf3645e27785674bcdf0e022ba88"
    sha256 cellar: :any,                 arm64_ventura:  "f7b01d022a5e9fa25698a2aef1435f7c0ed5c21a51b7f73cf55b517be4974ef5"
    sha256 cellar: :any,                 arm64_monterey: "b72d82c475f47201c4318413f5053f617a48b742ce701541336d21b20711c0e6"
    sha256 cellar: :any,                 sonoma:         "63c8e11132a0f13bbc45677dc3c46aed4781644c7132ed767a6a4b7994cfd58f"
    sha256 cellar: :any,                 ventura:        "8134ee401bffaa5cb8094ce2e26a7bc7adf2ba257aa2f5a934884a2bdc4f5ed6"
    sha256 cellar: :any,                 monterey:       "e9e5f26beddeff93544dcdb323ee5a9862abe36eff9ad76399a1f2e3a282c817"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a4bb5103f5a5fd7cd80d8fc61091a541b9ff37c0a3b0945d6af6f6e31dc34e1"
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

  # Upstream only directly supports and tests llvmclang builds.
  # GCC builds have limited support via community.
  fails_with :gcc

  def install
    if OS.mac?
      # Deparallelize to avoid missing PDBs
      ENV.deparallelize

      # Disable crossgen2 optimization in ASP.NET Core to work around build failure trying to find tool.
      # Microsoft.AspNetCore.App.Runtime.csproj(445,5): error : Could not find crossgen2 toolscrossgen2
      # TODO: Try to remove in future .NET 8 release or when macOS is officially supported in .NET 9
      inreplace "srcaspnetcoresrcFrameworkApp.RuntimesrcMicrosoft.AspNetCore.App.Runtime.csproj",
                "<CrossgenOutput Condition=\" '$(TargetArchitecture)' == 's390x'",
                "<CrossgenOutput Condition=\" '$(TargetOsName)' == 'osx'"
    else
      ENV.append_path "LD_LIBRARY_PATH", Formula["icu4c"].opt_lib
      ENV.append_to_cflags "-I#{Formula["krb5"].opt_include}"

      # Use our libunwind rather than the bundled one.
      inreplace "srcruntimeengSourceBuild.props",
                "--outputrid $(TargetRid)",
                "\\0 --cmakeargs -DCLR_CMAKE_USE_SYSTEM_LIBUNWIND=ON"

      # Work around build script getting stuck when running shutdown command on Linux
      # TODO: Try removing in the next release
      # Ref: https:github.comdotnetsource-builddiscussions3105#discussioncomment-4373142
      inreplace "build.sh", '"$CLI_ROOTdotnet" build-server shutdown', ""
      inreplace "repo-projectsDirectory.Build.targets",
                '<Exec Command="$(DotnetToolCommand) build-server shutdown" >',
                ""
    end

    system ".prep.sh"
    # We unset "CI" environment variable to work around aspire build failure
    # error MSB4057: The target "GitInfo" does not exist in the project.
    # Ref: https:github.comHomebrewhomebrew-corepull154584#issuecomment-1815575483
    with_env(CI: nil) do
      system ".build.sh", "--clean-while-building", "--online"
    end

    libexec.mkpath
    tarball = Dir["artifacts*Releasedotnet-sdk-*.tar.gz"].first
    system "tar", "-xzf", tarball, "--directory", libexec
    doc.install Dir[libexec"*.txt"]
    (bin"dotnet").write_env_script libexec"dotnet", DOTNET_ROOT: libexec

    bash_completion.install "srcsdkscriptsregister-completions.bash" => "dotnet"
    zsh_completion.install "srcsdkscriptsregister-completions.zsh" => "_dotnet"
    man1.install Dir["srcsdkdocumentationmanpagessdk*.1"]
    man7.install Dir["srcsdkdocumentationmanpagessdk*.7"]
  end

  def caveats
    <<~EOS
      For other software to find dotnet you may need to set:
        export DOTNET_ROOT="#{opt_libexec}"
    EOS
  end

  test do
    target_framework = "net#{version.major_minor}"
    (testpath"test.cs").write <<~EOS
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
    (testpath"test.csproj").write <<~EOS
      <Project Sdk="Microsoft.NET.Sdk">
        <PropertyGroup>
          <OutputType>Exe<OutputType>
          <TargetFrameworks>#{target_framework}<TargetFrameworks>
          <PlatformTarget>AnyCPU<PlatformTarget>
          <RootNamespace>Homebrew<RootNamespace>
          <PackageId>Homebrew.Dotnet<PackageId>
          <Title>Homebrew.Dotnet<Title>
          <Product>$(AssemblyName)<Product>
          <EnableDefaultCompileItems>false<EnableDefaultCompileItems>
        <PropertyGroup>
        <ItemGroup>
          <Compile Include="test.cs" >
        <ItemGroup>
      <Project>
    EOS
    system bin"dotnet", "build", "--framework", target_framework, "--output", testpath, testpath"test.csproj"
    assert_equal "#{testpath}test.dll,a,b,c\n",
                 shell_output("#{bin}dotnet run --framework #{target_framework} #{testpath}test.dll a b c")
  end
end