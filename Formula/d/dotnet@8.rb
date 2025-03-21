class DotnetAT8 < Formula
  desc ".NET Core"
  homepage "https:dotnet.microsoft.com"
  # Source-build tag announced at https:github.comdotnetsource-builddiscussions
  url "https:github.comdotnetdotnetarchiverefstagsv8.0.14.tar.gz"
  sha256 "a7b2f955a92f278feaf366bb0484e91b8248650f7e11bb079ff3616f34dc9787"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    regex(^v?(8(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2e1c4cb8e644f50be47509db117687a364c3f191bdb5ef167a309d282dfe68b1"
    sha256 cellar: :any,                 arm64_sonoma:  "16095a4f03a84b4b497357a88d09d858049b2a3295a41130b10ddfbe43fe27bc"
    sha256 cellar: :any,                 arm64_ventura: "97446e5f447b9241b2ad4acd04f77efa2941ec4bad9d106a2fe45a0ef8843d57"
    sha256 cellar: :any,                 ventura:       "b49d389eaca065c5ddc14395ca31434efd496986bc2b9e98459804f5a68e8229"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15b2c5e9c5ef956d5934da561c57c4870a75a6af28441651494fcb711148453d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57e8f351d9d2524a138bef3575b98e5c3ae0508c0bf179fe1c54a0befa9b626f"
  end

  keg_only :versioned_formula

  # https:dotnet.microsoft.comen-usplatformsupportpolicydotnet-core#lifecycle
  deprecate! date: "2026-11-10", because: :unsupported

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "icu4c@77"
  depends_on "openssl@3"

  uses_from_macos "python" => :build, since: :catalina
  uses_from_macos "krb5"
  uses_from_macos "zlib"

  on_macos do
    depends_on "grep" => :build # grep: invalid option -- P
  end

  on_linux do
    depends_on "libunwind"
    depends_on "lttng-ust"
  end

  resource "release.json" do
    url "https:github.comdotnetdotnetreleasesdownloadv8.0.14release.json"
    sha256 "9a99b5f5fc0861e597b6cba7b5b080890f593cba296af909cd02ea9fe12886b9"

    livecheck do
      formula :parent
    end
  end

  def install
    odie "Update release.json resource!" if resource("release.json").version != version
    buildpath.install resource("release.json")

    if OS.mac?
      # Need GNU grep (Perl regexp support) to use release manifest rather than git repo
      ENV.prepend_path "PATH", Formula["grep"].libexec"gnubin"

      # Avoid mixing CLT and Xcode.app when building CoreCLR component which can
      # cause undefined symbols, e.g. __swift_FORCE_LOAD_$_swift_Builtin_float
      ENV["SDKROOT"] = MacOS.sdk_path

      # Deparallelize to reduce chances of missing PDBs
      ENV.deparallelize
      # Avoid failing on missing PDBs as unable to build bottle on all runners in current state
      # Issue ref: https:github.comdotnetsource-buildissues4150
      inreplace "build.proj", \bFailOnMissingPDBs="true", 'FailOnMissingPDBs="false"'

      # Disable crossgen2 optimization in ASP.NET Core to work around build failure trying to find tool.
      # Microsoft.AspNetCore.App.Runtime.csproj(445,5): error : Could not find crossgen2 toolscrossgen2
      inreplace "srcaspnetcoresrcFrameworkApp.RuntimesrcMicrosoft.AspNetCore.App.Runtime.csproj",
                "<CrossgenOutput Condition=\" '$(TargetArchitecture)' == 's390x'",
                "<CrossgenOutput Condition=\" '$(TargetOsName)' == 'osx'"
    else
      icu4c_dep = deps.find { |dep| dep.name.match?(^icu4c(@\d+)?$) }
      ENV.append_path "LD_LIBRARY_PATH", icu4c_dep.to_formula.opt_lib

      # Use our libunwind rather than the bundled one.
      inreplace "srcruntimeengSourceBuild.props",
                "--outputrid $(TargetRid)",
                "\\0 --cmakeargs -DCLR_CMAKE_USE_SYSTEM_LIBUNWIND=ON"

      # Work around build script getting stuck when running shutdown command on Linux
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
      system ".build.sh", "--clean-while-building", "--online", "--release-manifest", "release.json"
    end

    libexec.mkpath
    tarball = buildpath.glob("artifacts*Releasedotnet-sdk-*.tar.gz").first
    system "tar", "--extract", "--file", tarball, "--directory", libexec
    doc.install libexec.glob("*.txt")
    (bin"dotnet").write_env_script libexec"dotnet", DOTNET_ROOT: libexec

    bash_completion.install "srcsdkscriptsregister-completions.bash" => "dotnet"
    zsh_completion.install "srcsdkscriptsregister-completions.zsh" => "_dotnet"
    man1.install Utils::Gzip.compress(*buildpath.glob("srcsdkdocumentationmanpagessdk*.1"))
    man7.install Utils::Gzip.compress(*buildpath.glob("srcsdkdocumentationmanpagessdk*.7"))
  end

  def caveats
    <<~TEXT
      For other software to find dotnet you may need to set:
        export DOTNET_ROOT="#{opt_libexec}"
    TEXT
  end

  test do
    target_framework = "net#{version.major_minor}"

    (testpath"test.cs").write <<~CSHARP
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
    CSHARP

    (testpath"test.csproj").write <<~XML
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
    XML

    system bin"dotnet", "build", "--framework", target_framework, "--output", testpath, testpath"test.csproj"
    output = shell_output("#{bin}dotnet run --framework #{target_framework} #{testpath}test.dll a b c")
    assert_equal "#{testpath}test.dll,a,b,c\n", output

    # Test to avoid uploading broken Intel Sonoma bottle which has stack overflow on restore.
    # See https:github.comHomebrewhomebrew-coreissues197546
    resource "sbom-tool" do
      url "https:github.commicrosoftsbom-toolarchiverefstagsv3.0.1.tar.gz"
      sha256 "90085ab1f134f83d43767e46d6952be42a62dbb0f5368e293437620a96458867"
    end
    resource("sbom-tool").stage do
      system bin"dotnet", "restore", "srcMicrosoft.Sbom.Tool", "--disable-build-servers", "--no-cache"
    end
  end
end