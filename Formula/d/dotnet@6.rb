class DotnetAT6 < Formula
  desc ".NET Core"
  homepage "https://dotnet.microsoft.com/"
  # Source-build tag announced at https://github.com/dotnet/source-build/discussions
  url "https://github.com/dotnet/installer.git",
      tag:      "v6.0.125",
      revision: "e898a826c2b7f66602c8962134ef165fb9e6d44b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "74ae1e9f647dad3ca8ef8f05559e23284c0ce23163beff75749b43df90b2577d"
    sha256 cellar: :any,                 arm64_monterey: "25fa40a478a1c3010c196bd29569675d4911cf68429fa570cfac9e75fd56254b"
    sha256 cellar: :any,                 ventura:        "d11fcc9a7a3a3c20197ce240a871323a44041ec7ef348007152fb3c0c2d907e4"
    sha256 cellar: :any,                 monterey:       "32cf49e5e8a0b4d431b0865d1e2d3844474259bd5fd744082264690dc7c682fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "beafa491d72204af7e2aa81b7a492a211b0db984b9030063a1955c5d646de49d"
  end

  keg_only :versioned_formula

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

  # Apple Silicon build fails due to latest dotnet-install.sh downloading x64 dotnet-runtime.
  # We work around the issue by using an older working copy of dotnet-install.sh script.
  # Bug introduced with https://github.com/dotnet/install-scripts/pull/314
  # TODO: Remove once script is fixed.
  # Issue ref: https://github.com/dotnet/install-scripts/issues/318
  resource "dotnet-install.sh" do
    url "https://ghproxy.com/https://raw.githubusercontent.com/dotnet/install-scripts/dac53157fcb7e02638507144bf5f8f019c1d23a8/src/dotnet-install.sh"
    sha256 "e96eabccea61bbbef3402e23f1889d385a6ae7ad84fe1d8f53f2507519ad86f7"
  end

  # Fixes race condition in MSBuild.
  # TODO: Remove with 6.0.3xx or later.
  resource "homebrew-msbuild-patch" do
    url "https://github.com/dotnet/msbuild/commit/64edb33a278d1334bd6efc35fecd23bd3af4ed48.patch?full_index=1"
    sha256 "5870bcdd12164668472094a2f9f1b73a4124e72ac99bbbe43028370be3648ccd"
  end

  # Fix build failure on macOS due to missing bootstrap packages
  # Fix build failure on macOS ARM due to `osx-x64` override
  # Issue ref: https://github.com/dotnet/source-build/issues/2795
  patch :DATA

  def install
    ENV.append_path "LD_LIBRARY_PATH", Formula["icu4c"].opt_lib if OS.linux?

    (buildpath/".dotnet").install resource("dotnet-install.sh")
    (buildpath/"src/SourceBuild/tarball/patches/msbuild").install resource("homebrew-msbuild-patch")

    # The source directory needs to be outside the installer directory
    (buildpath/"installer").install buildpath.children
    cd "installer" do
      system "./build.sh", "/p:ArcadeBuildTarball=true", "/p:TarballDir=#{buildpath}/sources"
    end

    cd "sources" do
      # Use our libunwind rather than the bundled one.
      inreplace "src/runtime/eng/SourceBuild.props",
                "/p:BuildDebPackage=false",
                "\\0 --cmakeargs -DCLR_CMAKE_USE_SYSTEM_LIBUNWIND=ON"

      # Fix Clang 15 error: definition of builtin function '__cpuid'.
      # Remove if following fix is backported to .NET 6.0.1xx
      # Ref: https://github.com/dotnet/runtime/commit/992cf8c97cc71d4ca9a0a11e6604a6716ed4cefc
      inreplace "src/runtime/src/coreclr/vm/amd64/unixstubs.cpp",
                /^ *void (__cpuid|__cpuidex)\([^}]*}$/,
                "#if !__has_builtin(\\1)\n\\0\n#endif"

      # Fix missing macOS conditional for system unwind searching.
      # Remove if following fix is backported to .NET 6.0.1xx
      # Ref: https://github.com/dotnet/runtime/commit/97c9a11e3e6ca68adf0c60155fa82ab3aae953a5
      inreplace "src/runtime/src/native/corehost/apphost/static/CMakeLists.txt",
                "if(CLR_CMAKE_USE_SYSTEM_LIBUNWIND)",
                "if(CLR_CMAKE_USE_SYSTEM_LIBUNWIND AND NOT CLR_CMAKE_TARGET_OSX)"

      # Work around arcade build failure with BSD `sed` due to non-compatible `-i`.
      # Remove if following fix is backported to .NET 6.0.1xx
      # Ref: https://github.com/dotnet/arcade/commit/b8007eed82adabd50c604a9849277a6e7be5c971
      inreplace "src/arcade/eng/SourceBuild.props", "\"sed -i ", "\"sed -i.bak " if OS.mac?

      # Rename patch fails on case-insensitive systems like macOS
      # TODO: Remove whenever patch is no longer used
      rename_patch = "0001-Rename-NuGet.Config-to-NuGet.config-to-account-for-a.patch"
      (Pathname("src/nuget-client/eng/source-build-patches")/rename_patch).unlink if OS.mac?

      prep_args = (OS.linux? && Hardware::CPU.intel?) ? [] : ["--bootstrap"]
      system "./prep.sh", *prep_args
      system "./build.sh", "--clean-while-building"

      libexec.mkpath
      tarball = Dir["artifacts/*/Release/dotnet-sdk-#{version}-*.tar.gz"].first
      system "tar", "-xzf", tarball, "--directory", libexec

      bash_completion.install "src/sdk/scripts/register-completions.bash" => "dotnet"
      zsh_completion.install "src/sdk/scripts/register-completions.zsh" => "_dotnet"
      man1.install Dir["src/sdk/documentation/manpages/sdk/*.1"]
    end

    doc.install Dir[libexec/"*.txt"]
    (bin/"dotnet").write_env_script libexec/"dotnet", DOTNET_ROOT: libexec
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

__END__
diff --git a/src/SourceBuild/tarball/content/repos/installer.proj b/src/SourceBuild/tarball/content/repos/installer.proj
index 712d7cd14..31d54866c 100644
--- a/src/SourceBuild/tarball/content/repos/installer.proj
+++ b/src/SourceBuild/tarball/content/repos/installer.proj
@@ -7,7 +7,7 @@

   <PropertyGroup>
     <OverrideTargetRid>$(TargetRid)</OverrideTargetRid>
-    <OverrideTargetRid Condition="'$(TargetOS)' == 'OSX'">osx-x64</OverrideTargetRid>
+    <OverrideTargetRid Condition="'$(TargetOS)' == 'OSX'">osx-$(Platform)</OverrideTargetRid>
     <OSNameOverride>$(OverrideTargetRid.Substring(0, $(OverrideTargetRid.IndexOf("-"))))</OSNameOverride>

     <RuntimeArg>--runtime-id $(OverrideTargetRid)</RuntimeArg>
@@ -28,7 +28,7 @@
     <BuildCommandArgs Condition="'$(TargetOS)' == 'Linux'">$(BuildCommandArgs) /p:AspNetCoreSharedFxInstallerRid=linux-$(Platform)</BuildCommandArgs>
     <!-- core-sdk always wants to build portable on OSX and FreeBSD -->
     <BuildCommandArgs Condition="'$(TargetOS)' == 'FreeBSD'">$(BuildCommandArgs) /p:CoreSetupRid=freebsd-x64 /p:PortableBuild=true</BuildCommandArgs>
-    <BuildCommandArgs Condition="'$(TargetOS)' == 'OSX'">$(BuildCommandArgs) /p:CoreSetupRid=osx-x64</BuildCommandArgs>
+    <BuildCommandArgs Condition="'$(TargetOS)' == 'OSX'">$(BuildCommandArgs) /p:CoreSetupRid=osx-$(Platform)</BuildCommandArgs>
     <BuildCommandArgs Condition="'$(TargetOS)' == 'Linux'">$(BuildCommandArgs) /p:CoreSetupRid=$(TargetRid)</BuildCommandArgs>

     <!-- Consume the source-built Core-Setup and toolset. This line must be removed to source-build CLI without source-building Core-Setup first. -->
diff --git a/src/SourceBuild/tarball/content/repos/runtime.proj b/src/SourceBuild/tarball/content/repos/runtime.proj
index f3ed143f8..2c62d6854 100644
--- a/src/SourceBuild/tarball/content/repos/runtime.proj
+++ b/src/SourceBuild/tarball/content/repos/runtime.proj
@@ -3,7 +3,7 @@

   <PropertyGroup>
     <OverrideTargetRid>$(TargetRid)</OverrideTargetRid>
-    <OverrideTargetRid Condition="'$(TargetOS)' == 'OSX'">osx-x64</OverrideTargetRid>
+    <OverrideTargetRid Condition="'$(TargetOS)' == 'OSX'">osx-$(Platform)</OverrideTargetRid>
     <OverrideTargetRid Condition="'$(TargetOS)' == 'FreeBSD'">freebsd-x64</OverrideTargetRid>
     <OverrideTargetRid Condition="'$(TargetOS)' == 'Windows_NT'">win-x64</OverrideTargetRid>

diff --git a/src/SourceBuild/tarball/content/scripts/bootstrap/buildBootstrapPreviouslySB.csproj b/src/SourceBuild/tarball/content/scripts/bootstrap/buildBootstrapPreviouslySB.csproj
index 14921a48f..3a34e8749 100644
--- a/src/SourceBuild/tarball/content/scripts/bootstrap/buildBootstrapPreviouslySB.csproj
+++ b/src/SourceBuild/tarball/content/scripts/bootstrap/buildBootstrapPreviouslySB.csproj
@@ -33,6 +33,14 @@
     <!-- There's no nuget package for runtime.linux-musl-x64.runtime.native.System.IO.Ports
     <PackageReference Include="runtime.linux-musl-x64.runtime.native.System.IO.Ports" Version="$(RuntimeLinuxX64RuntimeNativeSystemIOPortsVersion)" />
     -->
+    <PackageReference Include="runtime.osx-arm64.Microsoft.NETCore.ILAsm" Version="$(RuntimeLinuxX64MicrosoftNETCoreILAsmVersion)" />
+    <PackageReference Include="runtime.osx-arm64.Microsoft.NETCore.ILDAsm" Version="$(RuntimeLinuxX64MicrosoftNETCoreILDAsmVersion)" />
+    <PackageReference Include="runtime.osx-arm64.Microsoft.NETCore.TestHost" Version="$(RuntimeLinuxX64MicrosoftNETCoreTestHostVersion)" />
+    <PackageReference Include="runtime.osx-arm64.runtime.native.System.IO.Ports" Version="$(RuntimeLinuxX64RuntimeNativeSystemIOPortsVersion)" />
+    <PackageReference Include="runtime.osx-x64.Microsoft.NETCore.ILAsm" Version="$(RuntimeLinuxX64MicrosoftNETCoreILAsmVersion)" />
+    <PackageReference Include="runtime.osx-x64.Microsoft.NETCore.ILDAsm" Version="$(RuntimeLinuxX64MicrosoftNETCoreILDAsmVersion)" />
+    <PackageReference Include="runtime.osx-x64.Microsoft.NETCore.TestHost" Version="$(RuntimeLinuxX64MicrosoftNETCoreTestHostVersion)" />
+    <PackageReference Include="runtime.osx-x64.runtime.native.System.IO.Ports" Version="$(RuntimeLinuxX64RuntimeNativeSystemIOPortsVersion)" />
   </ItemGroup>

   <Target Name="BuildBoostrapPreviouslySourceBuilt" AfterTargets="Restore">