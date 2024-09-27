class Dotnet < Formula
  desc ".NET Core"
  homepage "https:dotnet.microsoft.com"
  # Source-build tag announced at https:github.comdotnetsource-builddiscussions
  url "https:github.comdotnetdotnet.git",
      tag:      "v8.0.8",
      revision: "e78e8a64f20e61e1fea4f24afca66ad1dc56285f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "56e9eb10fb113e33afa6c2f9184e32c0870348923b006fa69552dc1b97f94239"
    sha256 cellar: :any,                 arm64_sonoma:  "5252be281f673ff78c83c46a7063a85256ff5528d8bf8c03b9074fbb6ec310dc"
    sha256 cellar: :any,                 arm64_ventura: "365359b46dec4ffbc92479ba4dc3307015dc55046e91127142ff511d6c64955c"
    sha256 cellar: :any,                 sonoma:        "c018b3f6b3c2db277cbef6ea87b599da84358f20a2d6239f4574b6ad8a30798c"
    sha256 cellar: :any,                 ventura:       "8d5f216379964c3a8fd301870311e0d6d33f436128bffd104c02d03055433c85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d58cbbcb3443d41b3825720574f9fcf89ec18b5c01ba18ff94ece5cf8535c2de"
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
      ENV.append_path "LD_LIBRARY_PATH", Formula["icu4c"].opt_lib
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