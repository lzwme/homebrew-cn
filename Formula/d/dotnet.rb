class Dotnet < Formula
  desc ".NET Core"
  homepage "https:dotnet.microsoft.com"
  license "MIT"
  head "https:github.comdotnetdotnet.git", branch: "main"

  stable do
    # Source-build tag announced at https:github.comdotnetsource-builddiscussions
    url "https:github.comdotnetdotnetarchiverefstagsv9.0.0.tar.gz"
    sha256 "ade10f909a684c2a056b8b0ec3a30e1570ce2b83c46c5f621a4464d02729af9f"

    resource "release.json" do
      url "https:github.comdotnetdotnetreleasesdownloadv9.0.0release.json"
      sha256 "2a08862e4cd0095c743deccd8e34f3188261772cc775a7c6cdbfc9237727edda"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "846716ea37ae27f2be05098226bef127d27c650798f07085417ba8a610b1cf6f"
    sha256 cellar: :any,                 arm64_sonoma:  "f12bdbf90b2a57fc29349cb78123cd7f8eab584b27cf859c4413ae07a3f4a6bc"
    sha256 cellar: :any,                 arm64_ventura: "9a4970542023cb1cf76566978f7f6ee9d5e5b3890e47edc64d507468fc382558"
    sha256 cellar: :any,                 ventura:       "7e315138a9da1bb22c057f063d89d08297609a2196c2f6a5d25ccd405a6e2cef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23cad8699a8133d024cea4cb20f31d829911bffc9acd2586c9ea3811fd51df29"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rapidjson" => :build
  depends_on "brotli"
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
    # We switched to `assert_match` due to progress status ANSI codes in output.
    # TODO: Switch back to `assert_equal` once fixed in release.
    # Issue ref: https:github.comdotnetsdkissues44610
    assert_match "#{testpath}test.dll,a,b,c\n", output

    # Test to avoid uploading broken Intel Sonoma bottle which has stack overflow on restore.
    # See https:github.comHomebrewhomebrew-coreissues197546
    resource "docfx" do
      url "https:github.comdotnetdocfxarchiverefstagsv2.77.0.tar.gz"
      sha256 "03c13ca2cdb4a476365ef8f5b7f408a6cf6e35f0193c959d7765c03dd4884bfb"
    end
    resource("docfx").stage do
      system bin"dotnet", "restore", "srcdocfx", "--disable-build-servers", "--no-cache"
    end
  end
end