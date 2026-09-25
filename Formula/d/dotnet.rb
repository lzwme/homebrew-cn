class Dotnet < Formula
  desc ".NET Core"
  homepage "https://dotnet.microsoft.com/"
  license "MIT"
  version_scheme 1
  compatibility_version 7

  stable do
    # Source-build tag announced at https://github.com/dotnet/source-build/discussions
    url "https://ghfast.top/https://github.com/dotnet/dotnet/releases/download/v10.0.401/release.json"
    sha256 "6dc88b00a048b315868625e038212bfd06d2f9661254863848507ee4b70fdb36"

    resource "src" do
      url "https://ghfast.top/https://github.com/dotnet/dotnet/archive/refs/tags/v10.0.401.tar.gz"
      sha256 "3119efad4a965c5b9bf87fc795da50176cff73047b396981710b3f1aefb7d6af"

      livecheck do
        formula :parent
      end
    end

    # NOTE: 1xx band resources are only used when on 2xx/3xx/4xx band.
    # Can leave in formula even when unused to simplify version bumps.
    resource "1xx" do
      url "https://ghfast.top/https://github.com/dotnet/dotnet/archive/refs/tags/v10.0.112.tar.gz"
      sha256 "0107a6a9aca7635fcb66a90dd22269e42640797ce2ba0731c8669ba59f4e310d"

      livecheck do
        url "https://ghfast.top/https://github.com/dotnet/dotnet/releases/download/v#{LATEST_VERSION}/release.json"
        strategy :json do |json|
          channel_url = "https://builds.dotnet.microsoft.com/dotnet/release-metadata/#{json["channel"]}/releases.json"
          channel_json = JSON.parse(Homebrew::Livecheck::Strategy.page_content(channel_url)[:content])
          latest_release = channel_json["releases"].find { |release| release["release-version"] == json["release"] }
          latest_release["sdks"].filter_map do |sdk|
            v = Version.new(sdk["version"])
            v if v.patch.to_i.between?(100, 199)
          end
        end
      end
    end

    resource "1xx-manifest" do
      url "https://ghfast.top/https://github.com/dotnet/dotnet/releases/download/v10.0.112/release.json"
      sha256 "df14b07ce83d8b4d59c9dbb34f83ca6d8e1f99f41aa02133cba87f546a620db0"

      livecheck do
        url "https://ghfast.top/https://github.com/dotnet/dotnet/releases/download/v#{LATEST_VERSION}/release.json"
        strategy :json do |json|
          channel_url = "https://builds.dotnet.microsoft.com/dotnet/release-metadata/#{json["channel"]}/releases.json"
          channel_json = JSON.parse(Homebrew::Livecheck::Strategy.page_content(channel_url)[:content])
          latest_release = channel_json["releases"].find { |release| release["release-version"] == json["release"] }
          latest_release["sdks"].filter_map do |sdk|
            v = Version.new(sdk["version"])
            v if v.patch.to_i.between?(100, 199)
          end
        end
      end
    end
  end

  # Upstream has unstable tags that use the same version scheme as stable
  # releases so we cannot use the default :git strategy.
  livecheck do
    url :stable
    regex(/^v?(\d+\.\d+\.\d{3})$/i)
    strategy :github_releases
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "a5024a30fdc501d20ff89c6f5d9466fb6b6bcb2ff9322f3e0af70e6838a4e5fb"
    sha256 cellar: :any, arm64_tahoe:       "6dfc193bf00817200f19683c7993e7ce5b96240842aac662456b702323f9da7f"
    sha256 cellar: :any, arm64_sequoia:     "4c2036895068dff02de38d0d70e56106a3fb6d013cfd5685d2ffe474283e1094"
    sha256 cellar: :any, arm64_linux:       "a10b57d633642f97861efa31a614ef3667cd7606af1b4fe230eb6e712443777c"
    sha256 cellar: :any, x86_64_linux:      "e5d520ed9ebfd35b82e215de0aef3c5ace18b8809e74f7f02443c97b50d7f527"
  end

  head do
    url "https://github.com/dotnet/dotnet.git", branch: "main"

    depends_on "ninja" => :build
    depends_on "zstd"

    on_macos do
      depends_on xcode: :build # for xcodebuild
    end
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rapidjson" => :build
  depends_on "brotli"
  depends_on "icu4c@78"
  depends_on "openssl@3"

  uses_from_macos "cpio" => :build
  uses_from_macos "python" => :build
  uses_from_macos "krb5"

  on_macos do
    depends_on "bash" => :build
    depends_on "grep" => :build # grep: invalid option -- P
  end

  on_linux do
    depends_on "libunwind"
    depends_on "lttng-ust"
    depends_on "zlib-ng-compat"

    on_intel do
      depends_on "llvm" => :build

      fails_with :gcc do
        cause "Illegal instruction when running crossgen2"
      end
    end
  end

  # Perform "1xx" or "2xx/3xx/4xx" Band Bootstrap. Skipping stage 2 as didn't work via documented steps
  # https://github.com/dotnet/source-build/blob/main/Documentation/feature-band-source-building.md
  def bootstrap_build(with_shared_components: nil)
    args = %w[
      --clean-while-building
      --source-only
      --with-system-libs all
    ]
    args += ["--release-manifest", "release.json"] if build.stable?
    args += ["--with-shared-components", with_shared_components] if with_shared_components
    on_linux do
      args << "-p:PortableBuild=true"
    end

    on_macos do
      inreplace Dir["src/msbuild/src/{Shared,Framework/BackEnd}/NamedPipeUtil.cs"],
                      'Path.Combine("/tmp", pipeName)',
                      'Path.Combine(Path.GetTempPath().Length < 38 ? Path.GetTempPath() : "/tmp", pipeName)'
      # `prep-source-build.sh` runs binary detection with the prebuilt SDK, so patch its MSBuild first
      system "./prep-source-build.sh", "--no-binary-removal"
      # Avoid worker nodes, which the unpatched bootstrap MSBuild cannot reach
      system ".dotnet/dotnet", "build", "src/msbuild/src/MSBuild/MSBuild.csproj", "--configuration", "Release",
             "-maxcpucount:1"
      # Replace the bootstrap SDK's MSBuild with the patched one
      cp Dir["src/msbuild/artifacts/bin/MSBuild/Release/net*/{MSBuild,Microsoft.Build*}.dll"],
         Dir[".dotnet/sdk/*"].first
      # `build.sh` builds MSBuild again into the same directory
      rm_r "src/msbuild/artifacts"
    end
    system "./prep-source-build.sh"
    system "./build.sh", *args
    buildpath.install "artifacts/assets/Release"
  end

  def install
    # Make sure CoreCLR builds with our compiler shims
    ENV["CLR_CC"] = which(ENV.cc)
    ENV["CLR_CXX"] = which(ENV.cxx)
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"

    if OS.mac?
      # Need GNU grep (Perl regexp support) to use release manifest rather than git repo
      ENV.prepend_path "PATH", formula_opt_libexec("grep")/"gnubin"

      # Avoid mixing CLT and Xcode.app when building CoreCLR component which can
      # cause undefined symbols, e.g. __swift_FORCE_LOAD_$_swift_Builtin_float
      ENV["SDKROOT"] = MacOS.sdk_for_formula(self).path
    else
      icu4c_dep = deps.find { |dep| dep.name.match?(/^icu4c(@\d+)?$/) }
      ENV.append_path "LD_LIBRARY_PATH", icu4c_dep.to_formula.opt_lib
    end

    if build.head?
      (buildpath/"dotnet").install buildpath.children
    elsif version.patch.to_i < 200
      (buildpath/"dotnet").install resource("src"), "release.json"
    else
      (buildpath/"dotnet").install resource("1xx"), resource("1xx-manifest")

      release = JSON.parse(File.read("release.json"))["release"]
      release_1xx = JSON.parse(File.read("dotnet/release.json"))["release"]
      odie "1xx resource uses .NET Runtime #{release_1xx} but was expecting #{release}!" if release != release_1xx
      odie "Update 1xx and/or 1xx-manifest resource!" if resource("1xx").version != resource("1xx-manifest").version
    end

    cd "dotnet" do
      if build.stable?
        # Fixes build error where member names shadow type names
        # Error: declaration of '...' changes meaning of '...'
        inreplace "src/runtime/src/coreclr/jit/gentree.h" do |s|
          s.gsub! "    ExecutionContextHandling    ExecutionContextHandling",
                  "    ::ExecutionContextHandling    ExecutionContextHandling"
          s.gsub! "= ExecutionContextHandling::None;",
                  "= ::ExecutionContextHandling::None;"

          s.gsub! "    ContinuationContextHandling ContinuationContextHandling",
                  "    ::ContinuationContextHandling ContinuationContextHandling"
          s.gsub! "= ContinuationContextHandling::None;",
                  "= ::ContinuationContextHandling::None;"
        end
      end

      # Skip installer build on macOS - prevents CreatePkg target errors
      # See: https://github.com/dotnet/runtime/issues/122832
      if OS.mac?
        inreplace ["src/aspnetcore/Directory.Build.props", "src/runtime/Directory.Build.props"],
                  "</Project>",
                  "<PropertyGroup>\n    <SkipInstallerBuild>true</SkipInstallerBuild>\n  </PropertyGroup>\n</Project>"
      end

      bootstrap_build
    end

    if build.stable? && version.patch.to_i >= 200
      mkdir "1xx-artifacts"
      system "tar", "-ozxvf", Dir["Release/Private.SourceBuilt.Artifacts.*.tar.gz"].first, "-C", "1xx-artifacts"
      rm_r(["Release", "dotnet"])
      (buildpath/"dotnet").install resource("src"), "release.json"

      cd "dotnet" do
        chmod "+x", "src/diagnostics/eng/common/build.sh"
        bootstrap_build with_shared_components: buildpath/"1xx-artifacts"
      end
    end

    libexec.mkpath
    tarball = buildpath.glob("Release/dotnet-sdk-*.tar.gz").first
    system "tar", "--extract", "--file", tarball, "--directory", libexec

    if OS.linux?
      # Source-only builds default `KeepNativeSymbols` to true, so the native
      # binaries keep their DWARF. That leaves build paths in the binaries and
      # adds hundreds of MB to the x86_64 bottle. Upstream asks packagers to
      # strip downstream rather than flip that switch, see
      # https://github.com/dotnet/source-build/blob/main/Documentation/debugging-support.md
      # `--strip-debug` keeps `.symtab`, so native frames still symbolise, and
      # unlike an `--only-keep-debug` split it leaves no `.dbg` files behind.
      native_binaries = libexec.glob("**/*").select { |path| path.file? && path.elf? }
      system "strip", "--strip-debug", "--preserve-dates", *native_binaries
    end

    doc.install libexec.glob("*.txt")
    (bin/"dotnet").write_env_script libexec/"dotnet", DOTNET_ROOT: libexec

    bash_completion.install "dotnet/src/sdk/scripts/register-completions.bash" => "dotnet"
    zsh_completion.install "dotnet/src/sdk/scripts/register-completions.zsh" => "_dotnet"
    man1.install Utils::Gzip.compress(*buildpath.glob("dotnet/src/sdk/documentation/manpages/sdk/*.1"))
    man7.install Utils::Gzip.compress(*buildpath.glob("dotnet/src/sdk/documentation/manpages/sdk/*.7"))
  end

  def caveats
    <<~CAVEATS
      For other software to find dotnet you may need to set:
        export DOTNET_ROOT="#{opt_libexec}"
    CAVEATS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dotnet --version")

    target_framework = "net#{version.major_minor}"

    (testpath/"test.cs").write <<~CS
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

    (testpath/"test.csproj").write <<~XML
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
    XML

    system bin/"dotnet", "build", "--framework", target_framework, "--output", testpath, testpath/"test.csproj"
    output = shell_output("#{bin}/dotnet run --framework #{target_framework} #{testpath}/test.dll a b c")
    assert_equal "#{testpath}/test.dll,a,b,c\n", output

    # Test to avoid uploading broken Intel Sonoma bottle which has stack overflow on restore.
    # See https://github.com/Homebrew/homebrew-core/issues/197546
    resource "docfx" do
      url "https://ghfast.top/https://github.com/dotnet/docfx/archive/refs/tags/v2.78.5.tar.gz"
      sha256 "79f9e2c4bb8de2225d91a812a4e9d2cc71a8ed5613b3b4b2940d2a1d5db38793"
    end
    resource("docfx").stage do
      system bin/"dotnet", "restore", "src/docfx", "--disable-build-servers", "--no-cache"
    end
  end
end