class Dotnet < Formula
  desc ".NET Core"
  homepage "https:dotnet.microsoft.com"
  # Source-build tag announced at https:github.comdotnetsource-builddiscussions
  url "https:github.comdotnetdotnet.git",
      tag:      "v8.0.10",
      revision: "8922fe64a1903ed4e35e24568efb056b3e0fad43"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "197cb068d41882513946c97853080a27b7c314ffd8f42296b663d2a6a19277c4"
    sha256 cellar: :any,                 arm64_sonoma:  "ee8e38b1f895f854eb38256ce40ae985613b2c005881a64d58de86a7e0b9e24d"
    sha256 cellar: :any,                 arm64_ventura: "474fd3ad1582cf4f406654ec9b015e975569705c451e7f55d1a609a35b2da9ad"
    sha256 cellar: :any,                 sonoma:        "ef18da376e2734a3b327840e99aac667dd43b5c797e6b651aa875ed56644e2c4"
    sha256 cellar: :any,                 ventura:       "75c23fb3c05ac68ec3a3c22203e6829a8f80f5a2f22a3453bce1a4eff83338ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8bc8e2a21f664c9e49fba79e66c6e0fe53d8ad2eba046703ad536e47e5bb675"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.13" => :build
  depends_on "icu4c@76"
  depends_on "openssl@3"

  uses_from_macos "llvm" => :build
  uses_from_macos "krb5"
  uses_from_macos "zlib"

  on_sonoma do
    depends_on xcode: :build if DevelopmentTools.clang_build_version == 1600
  end

  on_linux do
    depends_on "libunwind"
    depends_on "lttng-ust"
  end

  # Upstream only directly supports and tests llvmclang builds.
  # GCC builds have limited support via community.
  fails_with :gcc

  # Backport fix for error loading BuildXL service index
  patch do
    url "https:github.comdotnetdotnetcommit18b5c7e1b125468f483a697ba8809c0a2412a762.patch?full_index=1"
    sha256 "76ede810166cf718fe430a8b155da07ca245ec9174b73b3471baf413bbd42460"
  end

  # Backport fix to build with Xcode 16
  patch do
    url "https:github.comdotnetruntimecommit562efd6824762dd0c1826cc99e006ad34a7e9e85.patch?full_index=1"
    sha256 "435002246227064be19db8065b945e94565b59362e75a72ee6d6322a25baa832"
    directory "srcruntime"
  end

  # Backport fix to build with Clang 19
  # Ref: https:github.comdotnetruntimecommit043ae8c50dbe1c7377cf5ad436c5ac1c226aef79
  patch :DATA

  def install
    if OS.mac?
      # Deparallelize to reduce chances of missing PDBs
      ENV.deparallelize
      # Avoid failing on missing PDBs as unable to build bottle on all runners in current state
      # Issue ref: https:github.comdotnetsource-buildissues4150
      inreplace "build.proj", \bFailOnMissingPDBs="true", 'FailOnMissingPDBs="false"'

      # Disable crossgen2 optimization in ASP.NET Core to work around build failure trying to find tool.
      # Microsoft.AspNetCore.App.Runtime.csproj(445,5): error : Could not find crossgen2 toolscrossgen2
      # TODO: Try to remove in future .NET 8 release or when macOS is officially supported in .NET 9
      inreplace "srcaspnetcoresrcFrameworkApp.RuntimesrcMicrosoft.AspNetCore.App.Runtime.csproj",
                "<CrossgenOutput Condition=\" '$(TargetArchitecture)' == 's390x'",
                "<CrossgenOutput Condition=\" '$(TargetOsName)' == 'osx'"
    else
      icu4c_dep = deps.find { |dep| dep.name.match?(^icu4c(@\d+)?$) }
      ENV.append_path "LD_LIBRARY_PATH", icu4c_dep.to_formula.opt_lib
      ENV.append_to_cflags "-I#{Formula["krb5"].opt_include}"
      ENV.append_to_cflags "-I#{Formula["zlib"].opt_include}"

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

__END__
diff --git asrcruntimesrccoreclrvmcomreflectioncache.hpp bsrcruntimesrccoreclrvmcomreflectioncache.hpp
index 08d173e61648c6ebb98a4d7323b30d40ec351d94..12db55251d80d24e3765a8fbe6e3b2d24a12f767 100644
--- asrcruntimesrccoreclrvmcomreflectioncache.hpp
+++ bsrcruntimesrccoreclrvmcomreflectioncache.hpp
@@ -26,6 +26,7 @@ template <class Element, class CacheType, int CacheSize> class ReflectionCache

     void Init();

+#ifndef DACCESS_COMPILE
     BOOL GetFromCache(Element *pElement, CacheType& rv)
     {
         CONTRACTL
@@ -102,6 +103,7 @@ template <class Element, class CacheType, int CacheSize> class ReflectionCache
         AdjustStamp(TRUE);
         this->LeaveWrite();
     }
+#endif  !DACCESS_COMPILE

 private:
      Lock must have been taken before calling this.
@@ -141,6 +143,7 @@ template <class Element, class CacheType, int CacheSize> class ReflectionCache
         return CacheSize;
     }

+#ifndef DACCESS_COMPILE
     void AdjustStamp(BOOL hasWriterLock)
     {
         CONTRACTL
@@ -170,6 +173,7 @@ template <class Element, class CacheType, int CacheSize> class ReflectionCache
         if (!hasWriterLock)
             this->LeaveWrite();
     }
+#endif  !DACCESS_COMPILE

     void UpdateHashTable(SIZE_T hash, int slot)
     {