class Dotnet < Formula
  desc ".NET Core"
  homepage "https:dotnet.microsoft.com"
  license "MIT"
  version_scheme 1
  head "https:github.comdotnetdotnet.git", branch: "main"

  stable do
    # Source-build tag announced at https:github.comdotnetsource-builddiscussions
    url "https:github.comdotnetdotnetarchiverefstagsv9.0.3.tar.gz"
    sha256 "958522190b818b28ecbfbd62bbf1d9317653122ac58ecbacdad9a98b0c38fd2b"

    resource "release.json" do
      url "https:github.comdotnetdotnetreleasesdownloadv9.0.3release.json"
      sha256 "a6097ecef565db41a66ef2c447043e5f0126509ff55bfa1257c62f8e636a0f42"

      livecheck do
        formula :parent
      end
    end
  end

  livecheck do
    url :stable
    regex(^v?(\d+\.\d+\.\d{1,2})$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "016ee84285215f529e099b48d0837950533aa86e64fcd33064728e26af5d8e0f"
    sha256 cellar: :any,                 arm64_sonoma:  "4db6cc2cb56fbeb0c42d9d0270b3eafa1cee2da98c3856c190a7aad40a4572e4"
    sha256 cellar: :any,                 arm64_ventura: "c5f600f9d4c715582e6478bdfd754e30b14f82ff996ae78c0e104a2f80111098"
    sha256 cellar: :any,                 ventura:       "a7f3e9843b38ecd3a6ff242e7cb0b43a92c8782fad398db4b773a77d5960cb18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1c32e5ead2aa52e36fa6af06b3de28265bdff707800113025253fb644c56479"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rapidjson" => :build
  depends_on "brotli"
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

  def install
    if OS.mac?
      # Need GNU grep (Perl regexp support) to use release manifest rather than git repo
      ENV.prepend_path "PATH", Formula["grep"].libexec"gnubin"

      # Avoid mixing CLT and Xcode.app when building CoreCLR component which can
      # cause undefined symbols, e.g. __swift_FORCE_LOAD_$_swift_Builtin_float
      ENV["SDKROOT"] = MacOS.sdk_path
    else
      icu4c_dep = deps.find { |dep| dep.name.match?(^icu4c(@\d+)?$) }
      ENV.append_path "LD_LIBRARY_PATH", icu4c_dep.to_formula.opt_lib

      # Work around build script getting stuck when running shutdown command on Linux
      # TODO: Try removing in the next release
      # Ref: https:github.comdotnetsource-builddiscussions3105#discussioncomment-4373142
      inreplace "build.sh", '"$CLI_ROOTdotnet" build-server shutdown', ""
      inreplace "repo-projectsDirectory.Build.targets",
                '"$(DotnetTool) build-server shutdown --vbcscompiler"',
                '"true"'
    end

    args = ["--clean-while-building", "--source-build", "--with-system-libs", "brotli+libunwind+rapidjson+zlib"]
    if build.stable?
      args += ["--release-manifest", "release.json"]
      odie "Update release.json resource!" if resource("release.json").version != version
      buildpath.install resource("release.json")
    end

    system ".prep-source-build.sh"
    # We unset "CI" environment variable to work around aspire build failure
    # error MSB4057: The target "GitInfo" does not exist in the project.
    # Ref: https:github.comHomebrewhomebrew-corepull154584#issuecomment-1815575483
    with_env(CI: nil) do
      system ".build.sh", *args
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
    <<~CAVEATS
      For other software to find dotnet you may need to set:
        export DOTNET_ROOT="#{opt_libexec}"
    CAVEATS
  end

  test do
    target_framework = "net#{version.major_minor}"

    (testpath"test.cs").write <<~CS
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
    CS

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
    # We switched to `assert_match` due to progress status ANSI codes in output.
    # TODO: Switch back to `assert_equal` once fixed in release.
    # Issue ref: https:github.comdotnetsdkissues44610
    assert_match "#{testpath}test.dll,a,b,c\n", output

    # Test to avoid uploading broken Intel Sonoma bottle which has stack overflow on restore.
    # See https:github.comHomebrewhomebrew-coreissues197546
    resource "docfx" do
      url "https:github.comdotnetdocfxarchiverefstagsv2.78.3.tar.gz"
      sha256 "d97142ff71bd84e200e6d121f09f57d28379a0c9d12cb58f23badad22cc5c1b7"
    end
    resource("docfx").stage do
      system bin"dotnet", "restore", "srcdocfx", "--disable-build-servers", "--no-cache"
    end
  end
end