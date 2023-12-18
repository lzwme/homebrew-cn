class Mono < Formula
  desc "Cross platform, open source .NET development framework"
  homepage "https:www.mono-project.com"
  url "https:download.mono-project.comsourcesmonomono-6.12.0.182.tar.xz"
  sha256 "57366a6ab4f3b5ecf111d48548031615b3a100db87c679fc006e8c8a4efd9424"
  license "MIT"

  bottle do
    rebuild 2
    sha256 arm64_monterey: "7c423e09da1607e5c80a8631fb4eb9f53869aca4c1bd702af36c3651a059f8dd"
    sha256 arm64_big_sur:  "1a755293d5bd0b4d646c752be882493bbd272b8502998f78b673091a9a5e78e8"
    sha256 sonoma:         "537d0087e718c8945d8c5acae07e0ec1f29706ee8b21610443a638d21ac42acc"
    sha256 ventura:        "a86886958f62a0456623b51ceeef71304a6b5bc4e98fd3f889a269e817987ec2"
    sha256 monterey:       "26fc159d687c2c647cbdc7d54c3100d47034a1bef41ad5bcd37ed28b17f338b1"
    sha256 big_sur:        "c319b187b5b7881bae3139a38028af4ae09f55acdd0a23b5dfe1deb04bab4372"
    sha256 x86_64_linux:   "e147b8ae7c32cda6c96a34bdd1de6f7d15c40af36b9ae68cb2196eb7e827e0a2"
  end

  deprecate! date: "2023-10-24", because: "uses deprecated `openssl@1.1`"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11"

  uses_from_macos "unzip" => :build
  uses_from_macos "krb5"
  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@1.1" => :build
    depends_on "ca-certificates"
  end

  on_arm do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  conflicts_with "xsd", because: "both install `xsd` binaries"
  conflicts_with cask: "mono-mdk"
  conflicts_with cask: "homebrewcask-versionsmono-mdk-for-visual-studio"

  # xbuild requires the .exe files inside the runtime directories to
  # be executable
  skip_clean "libmono"

  link_overwrite "binfsharpi"
  link_overwrite "binfsharpiAnyCpu"
  link_overwrite "binfsharpc"
  link_overwrite "binfssrgen"
  link_overwrite "libmono"
  link_overwrite "libcli"

  # When upgrading Mono, make sure to use the revision from
  # https:github.commonomonoblobmono-#{version}packagingMacSDKfsharp.py
  resource "fsharp" do
    url "https:github.comdotnetfsharp.git",
        revision: "9cf3dbdf4e83816a8feb2eab0dd48465d130f902"

    # F# patches from fsharp.py
    patch do
      url "https:raw.githubusercontent.commonomonoa22ed3f094e18f1f82e1c6cead28d872d3c57e40packagingMacSDKpatchesfsharp-portable-pdb.patch"
      sha256 "5b09b0c18b7815311680cc3ecd9bb30d92a307f3f2103a5b58b06bc3a0613ed4"
    end
    patch do
      url "https:raw.githubusercontent.commonomonoa22ed3f094e18f1f82e1c6cead28d872d3c57e40packagingMacSDKpatchesfsharp-netfx-multitarget.patch"
      sha256 "112f885d4833effb442cf586492cdbd7401d6c2ba9d8078fe55e896cc82624d7"
    end
  end

  # When upgrading Mono, make sure to use the revision from
  # https:github.commonomonoblobmono-#{version}packagingMacSDKmsbuild.py
  resource "msbuild" do
    url "https:github.commonomsbuild.git",
        revision: "63458bd6cb3a98b5a062bb18bd51ffdea4aa3001"

    # Fix build to use bash shebangs as the scripts have bashisms.
    # Patch is from mono's official packaging repo.
    on_linux do
      patch do
        url "https:raw.githubusercontent.commonolinux-packaging-msbuildde271a45e29b60a248b7b797cb49df6f3bedcb52debianpatchesfix_bashisms.patch"
        sha256 "81985224eeac5b9a2d6d8e3799d13eb9f083a1596d7adb713a49dd4db757aa61"
      end
    end
  end

  # Remove use of -flat_namespace. Upstreamed at
  # https:github.commonomonopull21257
  patch :DATA

  # Temporary patch remove in the next mono release
  patch do
    url "https:github.commonomonocommit3070886a1c5e3e3026d1077e36e67bd5310e0faa.patch?full_index=1"
    sha256 "b415d632ced09649f1a3c1b93ffce097f7c57dac843f16ec0c70dd93c9f64d52"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https:raw.githubusercontent.comHomebrewformula-patches03cf8088210822aa2c1ab544ed58ea04c897d9c4libtoolconfigure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  # Fix Ventura build issue reported at https:github.commonomonoissues21567
  # Patch lifted from dotnet https:github.comdotnetruntimepull76433
  patch do
    on_ventura :or_newer do
      url "https:raw.githubusercontent.comHomebrewformula-patchesdce4e25f7eacac188478ea9fbf61ce162f20811dmonoventura.diff"
      sha256 "d534e564b936f8929e50551f42edfc1fdf13a643cf0ee65955668b7fe52d3ce7"
    end
  end

  def install
    # Replace hardcoded usrshare directory. Paths like usrshare.mono,
    # usrshare.isolatedstorage, and usrsharetemplate are referenced in code.
    inreplace_files = %w[
      externalcorefxsrcSystem.Runtime.ExtensionssrcSystemEnvironment.Unix.cs
      mcsclasscorlibSystemEnvironment.cs
      mcsclasscorlibSystemEnvironment.iOS.cs
      manmono-configuration-crypto.1
      manmono.1
      manmozroots.1
    ]
    inreplace inreplace_files, %r{usrshare(?=["])}, pkgshare

    # Regenerate configure to fix ARM build: no member named '__r' in 'struct __darwin_arm_thread_state64'
    # Also apply our `patch :DATA` to Makefile.am as Makefile.in will be overwritten.
    # TODO: Remove once upstream release has a regenerated configure.
    if Hardware::CPU.arm?
      inreplace "monoprofilerMakefile.am", "-Wl,suppress -Wl,-flat_namespace", "-Wl,dynamic_lookup"
      system "autoreconf", "--force", "--install", "--verbose"
    end

    system ".configure", "--prefix=#{prefix}",
                          "--disable-silent-rules",
                          "--disable-nls"
    system "make"
    system "make", "install"
    # mono-gdb.py and mono-sgen-gdb.py are meant to be loaded by gdb, not to be
    # run directly, so we move them out of bin
    libexec.install bin"mono-gdb.py", bin"mono-sgen-gdb.py"

    # Populate temporary certificate store to allow MSBuild to access NuGet service index on Linux
    system bin"cert-sync", "--user", Formula["ca-certificates"].pkgetc"cert.pem" if OS.linux?

    # We'll need mono for msbuild, and then later msbuild for fsharp
    ENV.prepend_path "PATH", bin

    # Next build msbuild
    # NOTE: MSBuild 16 fails to build on Apple Silicon as it requires .NET 5
    # TODO: MSBuild 17 seems to use .NET 6 so can try enabling when available in mono.
    # PR ref: https:github.commonomsbuildpull435
    unless Hardware::CPU.arm?
      resource("msbuild").stage do
        system ".engcibuild_bootstrapped_msbuild.sh", "--host_type", "mono",
                                                        "--configuration", "Release",
                                                        "--skip_tests",
                                                        "p:DisableNerdbankVersioning=true"

        system ".stage1mono-msbuildmsbuild", "monobuildinstall.proj",
                                                "p:MonoInstallPrefix=#{prefix}",
                                                "p:Configuration=Release-MONO",
                                                "p:IgnoreDiffFailure=true"
      end
    end

    # Finally build and install fsharp as well
    resource("fsharp").stage do
      # Temporary fix for use proper .NET SDK remove in next release
      inreplace ".global.json", "3.1.302", "3.1.405"

      # Help .NET SDK run by providing path to libraries or disabling features
      if OS.linux?
        ENV["DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"] = "1"
        ENV["LD_LIBRARY_PATH"] = "#{Formula["openssl@1.1"].opt_lib}:#{HOMEBREW_PREFIX}lib"
      end

      with_env(version: "") do
        system ".build.sh", "--configuration", "Release"
      end
      with_env(version: "") do
        system "..dotnetdotnet", "restore", "setupSwixMicrosoft.FSharp.SDKMicrosoft.FSharp.SDK.csproj",
                                              "--packages", "fsharp-nugets"
      end
      system "bash", buildpath"packagingMacSDKfsharp-layout.sh", ".", prefix
    end

    # Try to work around `brew bottle` error from leftover processes
    # Error: Text file busy @ rb_sysopen - homelinuxbrew.linuxbrewCellarmono6.12.0.182binmono-sgen
    sleep 30 if OS.linux?
  end

  def post_install
    system bin"cert-sync", Formula["ca-certificates"].pkgetc"cert.pem" if OS.linux?
  end

  def caveats
    s = <<~EOS
      To use the assemblies from other formulae you need to set:
        export MONO_GAC_PREFIX="#{HOMEBREW_PREFIX}"
    EOS
    on_arm do
      s += <<~EOS

        `mono` does not include MSBuild on Apple Silicon as current version
        requires .NET 5 but Apple Silicon support was added in .NET 6.
        If you need a complete package, then install via Rosetta or as a Cask.
      EOS
    end
    s
  end

  test do
    test_str = "Hello Homebrew"
    test_name = "hello.cs"
    (testpathtest_name).write <<~EOS
      public class Hello1
      {
         public static void Main()
         {
            System.Console.WriteLine("#{test_str}");
         }
      }
    EOS
    shell_output("#{bin}mcs #{test_name}")
    output = shell_output("#{bin}mono hello.exe")
    assert_match test_str, output.strip

    # Test that fsharpi is working
    ENV.prepend_path "PATH", bin
    (testpath"test.fsx").write <<~EOS
      printfn "#{test_str}"; 0
    EOS
    output = pipe_output("#{bin}fsharpi test.fsx")
    assert_match test_str, output

    # TODO: re-enable xbuild tests once MSBuild is included with Apple Silicon
    return if Hardware::CPU.arm?

    # Tests that xbuild is able to execute libmono*mcs.exe
    (testpath"test.csproj").write <<~EOS
      <?xml version="1.0" encoding="utf-8"?>
      <Project ToolsVersion="4.0" DefaultTargets="Build" xmlns="http:schemas.microsoft.comdevelopermsbuild2003">
        <PropertyGroup>
          <AssemblyName>HomebrewMonoTest<AssemblyName>
          <TargetFrameworkVersion>v4.5<TargetFrameworkVersion>
        <PropertyGroup>
        <ItemGroup>
          <Compile Include="#{test_name}" >
        <ItemGroup>
        <Import Project="$(MSBuildBinPath)\\Microsoft.CSharp.targets" >
      <Project>
    EOS
    system bin"msbuild", "test.csproj"

    # Tests that xbuild is able to execute fsc.exe
    (testpath"test.fsproj").write <<~EOS
      <?xml version="1.0" encoding="utf-8"?>
      <Project ToolsVersion="4.0" DefaultTargets="Build" xmlns="http:schemas.microsoft.comdevelopermsbuild2003">
        <PropertyGroup>
          <ProductVersion>8.0.30703<ProductVersion>
          <SchemaVersion>2.0<SchemaVersion>
          <ProjectGuid>{B6AB4EF3-8F60-41A1-AB0C-851A6DEB169E}<ProjectGuid>
          <OutputType>Exe<OutputType>
          <FSharpTargetsPath>$(MSBuildExtensionsPath32)\\Microsoft\\VisualStudio\\v$(VisualStudioVersion)\\FSharp\\Microsoft.FSharp.Targets<FSharpTargetsPath>
          <TargetFrameworkVersion>v4.7.2<TargetFrameworkVersion>
        <PropertyGroup>
        <Import Project="$(FSharpTargetsPath)" Condition="Exists('$(FSharpTargetsPath)')" >
        <ItemGroup>
          <Compile Include="Main.fs" >
        <ItemGroup>
        <ItemGroup>
          <Reference Include="mscorlib" >
          <Reference Include="System" >
          <Reference Include="FSharp.Core" >
        <ItemGroup>
      <Project>
    EOS
    (testpath"Main.fs").write <<~EOS
      [<EntryPoint>]
      let main _ = printfn "#{test_str}"; 0
    EOS
    system bin"msbuild", "test.fsproj"
  end
end

__END__
diff --git amonoprofilerMakefile.in bmonoprofilerMakefile.in
index 48bcfad..58273a5 100644
--- amonoprofilerMakefile.in
+++ bmonoprofilerMakefile.in
@@ -647,7 +647,7 @@ glib_libs = $(top_builddir)monoegliblibeglib.la
 #
 # See: https:bugzilla.xamarin.comshow_bug.cgi?id=57011
 @DISABLE_LIBRARIES_FALSE@@DISABLE_PROFILER_FALSE@@ENABLE_COOP_SUSPEND_FALSE@@HOST_WIN32_FALSE@check_targets = run-test
-@BITCODE_FALSE@@HOST_DARWIN_TRUE@prof_ldflags = -Wl,-undefined -Wl,suppress -Wl,-flat_namespace
+@BITCODE_FALSE@@HOST_DARWIN_TRUE@prof_ldflags = -Wl,-undefined -Wl,dynamic_lookup

 # On Apple hosts, we want to allow undefined symbols when building the
 # profiler modules as, just like on Linux, we don't link them to libmono,