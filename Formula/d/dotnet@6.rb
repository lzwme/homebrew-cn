class DotnetAT6 < Formula
  desc ".NET Core"
  homepage "https:dotnet.microsoft.com"
  # Source-build tag announced at https:github.comdotnetsource-builddiscussions
  url "https:github.comdotnetinstaller.git",
      tag:      "v6.0.133",
      revision: "48ad8f7176f00900ff49df9fb936bc7c8c79d345"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma: "3eb824051504d2753ab5cca847f0b943bc4dc05fb403558d18fe18c5532c3845"
    sha256 cellar: :any,                 sonoma:       "2f19620dfb82a8bcbcec0a68175426c64ff43e3fa231cf9d05ef21e8616572b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ffe54b54568dd28475dde52acdcd69cba25cd2b4a94ec568908e164477024045"
  end

  keg_only :versioned_formula

  # https:dotnet.microsoft.comen-usplatformsupportpolicydotnet-core#lifecycle
  deprecate! date: "2024-11-12", because: :unsupported

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.13" => :build
  depends_on "icu4c@75"
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

  # Apple Silicon build fails due to latest dotnet-install.sh downloading x64 dotnet-runtime.
  # We work around the issue by using an older working copy of dotnet-install.sh script.
  # Bug introduced with https:github.comdotnetinstall-scriptspull314
  # TODO: Remove once script is fixed.
  # Issue ref: https:github.comdotnetinstall-scriptsissues318
  resource "dotnet-install.sh" do
    url "https:raw.githubusercontent.comdotnetinstall-scriptsdac53157fcb7e02638507144bf5f8f019c1d23a8srcdotnet-install.sh"
    sha256 "e96eabccea61bbbef3402e23f1889d385a6ae7ad84fe1d8f53f2507519ad86f7"
  end

  # Fixes race condition in MSBuild.
  # TODO: Remove with 6.0.3xx or later.
  resource "homebrew-msbuild-patch" do
    url "https:github.comdotnetmsbuildcommit64edb33a278d1334bd6efc35fecd23bd3af4ed48.patch?full_index=1"
    sha256 "5870bcdd12164668472094a2f9f1b73a4124e72ac99bbbe43028370be3648ccd"
  end

  # Fix build failure on macOS due to missing bootstrap packages
  # Fix build failure on macOS ARM due to `osx-x64` override
  # Issue ref: https:github.comdotnetsource-buildissues2795
  patch :DATA

  # Backport fix to build with Clang 19
  # Ref: https:github.comdotnetruntimecommit043ae8c50dbe1c7377cf5ad436c5ac1c226aef79
  def clang19_patch
    <<~EOS
      diff --git asrccoreclrvmcomreflectioncache.hpp bsrccoreclrvmcomreflectioncache.hpp
      index 08d173e61648c6ebb98a4d7323b30d40ec351d94..12db55251d80d24e3765a8fbe6e3b2d24a12f767 100644
      --- asrccoreclrvmcomreflectioncache.hpp
      +++ bsrccoreclrvmcomreflectioncache.hpp
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
    EOS
  end

  def install
    if OS.linux?
      icu4c = deps.map(&:to_formula).find { |f| f.name.match?(^icu4c@\d+$) }
      ENV.append_path "LD_LIBRARY_PATH", icu4c.opt_lib if OS.linux?
      ENV.append_to_cflags "-I#{Formula["krb5"].opt_include}"
      ENV.append_to_cflags "-I#{Formula["zlib"].opt_include}"
    end

    (buildpath".dotnet").install resource("dotnet-install.sh")
    (buildpath"srcSourceBuildtarballpatchesmsbuild").install resource("homebrew-msbuild-patch")
    (buildpath"srcSourceBuildtarballpatchesruntimeclang19.patch").write clang19_patch

    # The source directory needs to be outside the installer directory
    (buildpath"installer").install buildpath.children
    cd "installer" do
      system ".build.sh", "p:ArcadeBuildTarball=true", "p:TarballDir=#{buildpath}sources"
    end

    cd "sources" do
      # Use our libunwind rather than the bundled one.
      inreplace "srcruntimeengSourceBuild.props",
                "p:BuildDebPackage=false",
                "\\0 --cmakeargs -DCLR_CMAKE_USE_SYSTEM_LIBUNWIND=ON"

      # Fix Clang 15 error: definition of builtin function '__cpuid'.
      # Remove if following fix is backported to .NET 6.0.1xx
      # Ref: https:github.comdotnetruntimecommit992cf8c97cc71d4ca9a0a11e6604a6716ed4cefc
      inreplace "srcruntimesrccoreclrvmamd64unixstubs.cpp",
                ^ *void (__cpuid|__cpuidex)\([^}]*}$,
                "#if !__has_builtin(\\1)\n\\0\n#endif"

      # Fix missing macOS conditional for system unwind searching.
      # Remove if following fix is backported to .NET 6.0.1xx
      # Ref: https:github.comdotnetruntimecommit97c9a11e3e6ca68adf0c60155fa82ab3aae953a5
      inreplace "srcruntimesrcnativecorehostapphoststaticCMakeLists.txt",
                "if(CLR_CMAKE_USE_SYSTEM_LIBUNWIND)",
                "if(CLR_CMAKE_USE_SYSTEM_LIBUNWIND AND NOT CLR_CMAKE_TARGET_OSX)"

      # Work around arcade build failure with BSD `sed` due to non-compatible `-i`.
      # Remove if following fix is backported to .NET 6.0.1xx
      # Ref: https:github.comdotnetarcadecommitb8007eed82adabd50c604a9849277a6e7be5c971
      inreplace "srcarcadeengSourceBuild.props", "\"sed -i ", "\"sed -i.bak " if OS.mac?

      # Rename patch fails on case-insensitive systems like macOS
      # TODO: Remove whenever patch is no longer used
      rename_patch = "0001-Rename-NuGet.Config-to-NuGet.config-to-account-for-a.patch"
      (Pathname("srcnuget-clientengsource-build-patches")rename_patch).unlink if OS.mac?

      prep_args = (OS.linux? && Hardware::CPU.intel?) ? [] : ["--bootstrap"]
      system ".prep.sh", *prep_args
      system ".build.sh", "--clean-while-building"

      libexec.mkpath
      tarball = Dir["artifacts*Releasedotnet-sdk-#{version}-*.tar.gz"].first
      system "tar", "-xzf", tarball, "--directory", libexec

      bash_completion.install "srcsdkscriptsregister-completions.bash" => "dotnet"
      zsh_completion.install "srcsdkscriptsregister-completions.zsh" => "_dotnet"
      man1.install Dir["srcsdkdocumentationmanpagessdk*.1"]
    end

    doc.install Dir[libexec"*.txt"]
    (bin"dotnet").write_env_script libexec"dotnet", DOTNET_ROOT: libexec
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
diff --git asrcSourceBuildtarballcontentreposinstaller.proj bsrcSourceBuildtarballcontentreposinstaller.proj
index 712d7cd14..31d54866c 100644
--- asrcSourceBuildtarballcontentreposinstaller.proj
+++ bsrcSourceBuildtarballcontentreposinstaller.proj
@@ -7,7 +7,7 @@

   <PropertyGroup>
     <OverrideTargetRid>$(TargetRid)<OverrideTargetRid>
-    <OverrideTargetRid Condition="'$(TargetOS)' == 'OSX'">osx-x64<OverrideTargetRid>
+    <OverrideTargetRid Condition="'$(TargetOS)' == 'OSX'">osx-$(Platform)<OverrideTargetRid>
     <OSNameOverride>$(OverrideTargetRid.Substring(0, $(OverrideTargetRid.IndexOf("-"))))<OSNameOverride>

     <RuntimeArg>--runtime-id $(OverrideTargetRid)<RuntimeArg>
@@ -28,7 +28,7 @@
     <BuildCommandArgs Condition="'$(TargetOS)' == 'Linux'">$(BuildCommandArgs) p:AspNetCoreSharedFxInstallerRid=linux-$(Platform)<BuildCommandArgs>
     <!-- core-sdk always wants to build portable on OSX and FreeBSD -->
     <BuildCommandArgs Condition="'$(TargetOS)' == 'FreeBSD'">$(BuildCommandArgs) p:CoreSetupRid=freebsd-x64 p:PortableBuild=true<BuildCommandArgs>
-    <BuildCommandArgs Condition="'$(TargetOS)' == 'OSX'">$(BuildCommandArgs) p:CoreSetupRid=osx-x64<BuildCommandArgs>
+    <BuildCommandArgs Condition="'$(TargetOS)' == 'OSX'">$(BuildCommandArgs) p:CoreSetupRid=osx-$(Platform)<BuildCommandArgs>
     <BuildCommandArgs Condition="'$(TargetOS)' == 'Linux'">$(BuildCommandArgs) p:CoreSetupRid=$(TargetRid)<BuildCommandArgs>

     <!-- Consume the source-built Core-Setup and toolset. This line must be removed to source-build CLI without source-building Core-Setup first. -->
diff --git asrcSourceBuildtarballcontentreposruntime.proj bsrcSourceBuildtarballcontentreposruntime.proj
index f3ed143f8..2c62d6854 100644
--- asrcSourceBuildtarballcontentreposruntime.proj
+++ bsrcSourceBuildtarballcontentreposruntime.proj
@@ -3,7 +3,7 @@

   <PropertyGroup>
     <OverrideTargetRid>$(TargetRid)<OverrideTargetRid>
-    <OverrideTargetRid Condition="'$(TargetOS)' == 'OSX'">osx-x64<OverrideTargetRid>
+    <OverrideTargetRid Condition="'$(TargetOS)' == 'OSX'">osx-$(Platform)<OverrideTargetRid>
     <OverrideTargetRid Condition="'$(TargetOS)' == 'FreeBSD'">freebsd-x64<OverrideTargetRid>
     <OverrideTargetRid Condition="'$(TargetOS)' == 'Windows_NT'">win-x64<OverrideTargetRid>

diff --git asrcSourceBuildtarballcontentscriptsbootstrapbuildBootstrapPreviouslySB.csproj bsrcSourceBuildtarballcontentscriptsbootstrapbuildBootstrapPreviouslySB.csproj
index 14921a48f..3a34e8749 100644
--- asrcSourceBuildtarballcontentscriptsbootstrapbuildBootstrapPreviouslySB.csproj
+++ bsrcSourceBuildtarballcontentscriptsbootstrapbuildBootstrapPreviouslySB.csproj
@@ -33,6 +33,14 @@
     <!-- There's no nuget package for runtime.linux-musl-x64.runtime.native.System.IO.Ports
     <PackageReference Include="runtime.linux-musl-x64.runtime.native.System.IO.Ports" Version="$(RuntimeLinuxX64RuntimeNativeSystemIOPortsVersion)" >
     -->
+    <PackageReference Include="runtime.osx-arm64.Microsoft.NETCore.ILAsm" Version="$(RuntimeLinuxX64MicrosoftNETCoreILAsmVersion)" >
+    <PackageReference Include="runtime.osx-arm64.Microsoft.NETCore.ILDAsm" Version="$(RuntimeLinuxX64MicrosoftNETCoreILDAsmVersion)" >
+    <PackageReference Include="runtime.osx-arm64.Microsoft.NETCore.TestHost" Version="$(RuntimeLinuxX64MicrosoftNETCoreTestHostVersion)" >
+    <PackageReference Include="runtime.osx-arm64.runtime.native.System.IO.Ports" Version="$(RuntimeLinuxX64RuntimeNativeSystemIOPortsVersion)" >
+    <PackageReference Include="runtime.osx-x64.Microsoft.NETCore.ILAsm" Version="$(RuntimeLinuxX64MicrosoftNETCoreILAsmVersion)" >
+    <PackageReference Include="runtime.osx-x64.Microsoft.NETCore.ILDAsm" Version="$(RuntimeLinuxX64MicrosoftNETCoreILDAsmVersion)" >
+    <PackageReference Include="runtime.osx-x64.Microsoft.NETCore.TestHost" Version="$(RuntimeLinuxX64MicrosoftNETCoreTestHostVersion)" >
+    <PackageReference Include="runtime.osx-x64.runtime.native.System.IO.Ports" Version="$(RuntimeLinuxX64RuntimeNativeSystemIOPortsVersion)" >
   <ItemGroup>

   <Target Name="BuildBoostrapPreviouslySourceBuilt" AfterTargets="Restore">