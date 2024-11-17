class DotnetAT8 < Formula
  desc ".NET Core"
  homepage "https:dotnet.microsoft.com"
  # Source-build tag announced at https:github.comdotnetsource-builddiscussions
  url "https:github.comdotnetdotnetarchiverefstagsv8.0.11.tar.gz"
  sha256 "d7cb383bbfa20f86e085615ab3dcb769e5c9af7330d90834ce34889857bd92e5"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(8(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "92f8ec953388502d9d76fec33366fbd6693b5256a29bf54b0e5680db9dbfbef9"
    sha256 cellar: :any,                 arm64_sonoma:  "0508065a204cb17ea203222d3b81fafd0b782e9eeca37f34c3fee7fad5fbb701"
    sha256 cellar: :any,                 arm64_ventura: "ad714d85bb529c518fb1dc1d4f4cb906509039960ad5226be9620cb310f8f66c"
    sha256 cellar: :any,                 ventura:       "f82094589ae3d400912a21ea9c70764c680fcda0e2b9ca779001686c98b371f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2fa6691f08d7c23a8090f163d2074424eb3c1365170706248956ebe0c7460922"
  end

  keg_only :versioned_formula

  # https:dotnet.microsoft.comen-usplatformsupportpolicydotnet-core#lifecycle
  deprecate! date: "2026-11-10", because: :unsupported

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "icu4c@76"
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
    url "https:github.comdotnetdotnetreleasesdownloadv8.0.11release.json"
    sha256 "585e6094fa25acc8b8907220b6c8a167ba3611fc082c1b220486df1cebce4caf"
  end

  # Backport fix to build with Xcode 16
  patch do
    url "https:github.comdotnetruntimecommit562efd6824762dd0c1826cc99e006ad34a7e9e85.patch?full_index=1"
    sha256 "435002246227064be19db8065b945e94565b59362e75a72ee6d6322a25baa832"
    directory "srcruntime"
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