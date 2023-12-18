class MoltenVk < Formula
  desc "Implementation of the Vulkan graphics and compute API on top of Metal"
  homepage "https:github.comKhronosGroupMoltenVK"
  license "Apache-2.0"

  stable do
    url "https:github.comKhronosGroupMoltenVKarchiverefstagsv1.2.6.tar.gz"
    sha256 "b6a3d179aa9c41275ed0e35e502e5e3fd347dbe5117a0435a26868b231cd6246"

    # MoltenVK depends on very specific revisions of its dependencies.
    # For each resource the path to the file describing the expected
    # revision is listed.
    resource "SPIRV-Cross" do
      # ExternalRevisionsSPIRV-Cross_repo_revision
      url "https:github.comKhronosGroupSPIRV-Cross.git",
          revision: "2de1265fca722929785d9acdec4ab728c47a0254"
    end

    resource "Vulkan-Headers" do
      # ExternalRevisionsVulkan-Headers_repo_revision
      url "https:github.comKhronosGroupVulkan-Headers.git",
          revision: "7b3466a1f47a9251ac1113efbe022ff016e2f95b"
    end

    resource "Vulkan-Tools" do
      # ExternalRevisionsVulkan-Tools_repo_revision
      url "https:github.comKhronosGroupVulkan-Tools.git",
          revision: "1532001f7edae559af1988293eec90bc5e2607d5"
    end

    resource "cereal" do
      # ExternalRevisionscereal_repo_revision
      url "https:github.comUSCiLabcereal.git",
          revision: "51cbda5f30e56c801c07fe3d3aba5d7fb9e6cca4"
    end

    resource "glslang" do
      # ExternalRevisionsglslang_repo_revision
      url "https:github.comKhronosGroupglslang.git",
          revision: "be564292f00c5bf0d7251c11f1c9618eb1117762"
    end

    resource "SPIRV-Tools" do
      # known_good.json in the glslang repository at revision of resource above
      url "https:github.comKhronosGroupSPIRV-Tools.git",
          revision: "360d469b9eac54d6c6e20f609f9ec35e3a5380ad"
    end

    resource "SPIRV-Headers" do
      # known_good.json in the glslang repository at revision of resource above
      url "https:github.comKhronosGroupSPIRV-Headers.git",
          revision: "e867c06631767a2d96424cbec530f9ee5e78180f"
    end
  end

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_sonoma:   "824854916a8585d9ca8c4aa5320207c6c7d9a17ea80231a296353cc99c7c67ec"
    sha256 cellar: :any, arm64_ventura:  "ef70b4f7386544e4501ca678d0c4161675bd7255cdd2feed40236dbd93dd3733"
    sha256 cellar: :any, arm64_monterey: "582db3ddb81439b7d6a6521b0173615906c903ff13bf2a59e1c07d6ce13732f2"
    sha256 cellar: :any, sonoma:         "1b6217a945ce747dbdfd73d628bdaff2522929cdecd0e37f8a10ef5af53ba9f3"
    sha256 cellar: :any, ventura:        "95c0a376b5e4b736fa409d2871897da543497554519eefcfce1ae1cb94bd012f"
    sha256 cellar: :any, monterey:       "a5d0472bbc7c2049f070aa19b3f7b6f70f6c1d9538400ccf619fe8636e781609"
  end

  head do
    url "https:github.comKhronosGroupMoltenVK.git", branch: "main"

    resource "cereal" do
      url "https:github.comUSCiLabcereal.git", branch: "master"
    end

    resource "Vulkan-Headers" do
      url "https:github.comKhronosGroupVulkan-Headers.git", branch: "main"
    end

    resource "SPIRV-Cross" do
      url "https:github.comKhronosGroupSPIRV-Cross.git", branch: "main"
    end

    resource "glslang" do
      url "https:github.comKhronosGroupglslang.git", branch: "main"
    end

    resource "SPIRV-Tools" do
      url "https:github.comKhronosGroupSPIRV-Tools.git", branch: "main"
    end

    resource "SPIRV-Headers" do
      url "https:github.comKhronosGroupSPIRV-Headers.git", branch: "main"
    end

    resource "Vulkan-Tools" do
      url "https:github.comKhronosGroupVulkan-Tools.git", branch: "main"
    end
  end

  depends_on "cmake" => :build
  depends_on "python@3.11" => :build
  depends_on xcode: ["11.7", :build]
  # Requires IOSurfaceIOSurfaceRef.h.
  depends_on macos: :sierra
  depends_on :macos # Linux does not have a Metal implementation. Not implied by the line above.

  def install
    resources.each do |res|
      res.stage(buildpath"External"res.name)
    end
    mv "ExternalSPIRV-Tools", "ExternalglslangExternalspirv-tools"
    mv "ExternalSPIRV-Headers", "ExternalglslangExternalspirv-toolsexternalspirv-headers"

    # Build glslang
    cd "Externalglslang" do
      system ".build_info.py", ".",
              "-i", "build_info.h.tmpl",
              "-o", "buildincludeglslangbuild_info.h"
    end

    # Build spirv-tools
    mkdir "ExternalglslangExternalspirv-toolsbuild" do
      # Required due to files being generated during build.
      system "cmake", "..", *std_cmake_args
      system "make"
    end

    # Build ExternalDependencies
    xcodebuild "ARCHS=#{Hardware::CPU.arch}", "ONLY_ACTIVE_ARCH=YES",
               "-project", "ExternalDependencies.xcodeproj",
               "-scheme", "ExternalDependencies-macOS",
               "-derivedDataPath", "Externalbuild",
               "SYMROOT=Externalbuild", "OBJROOT=Externalbuild",
               "build"

    if DevelopmentTools.clang_build_version >= 1500
      # Required to build xcframeworks with Xcode 15
      # https:github.comKhronosGroupMoltenVKissues2028
      xcodebuild "-create-xcframework", "-output", ".ExternalbuildReleaseSPIRVCross.xcframework",
                "-library", ".ExternalbuildIntermediatesXCFrameworkStagingReleasePlatformlibSPIRVCross.a"
      xcodebuild "-create-xcframework", "-output", ".ExternalbuildReleaseSPIRVTools.xcframework",
                "-library", ".ExternalbuildIntermediatesXCFrameworkStagingReleasePlatformlibSPIRVTools.a"
      xcodebuild "-create-xcframework", "-output", ".ExternalbuildReleaseglslang.xcframework",
                "-library", ".ExternalbuildIntermediatesXCFrameworkStagingReleasePlatformlibglslang.a"
    end

    # Build MoltenVK Package
    xcodebuild "ARCHS=#{Hardware::CPU.arch}", "ONLY_ACTIVE_ARCH=YES",
               "-project", "MoltenVKPackaging.xcodeproj",
               "-scheme", "MoltenVK Package (macOS only)",
               "-derivedDataPath", "#{buildpath}build",
               "SYMROOT=#{buildpath}build", "OBJROOT=build",
               "GCC_PREPROCESSOR_DEFINITIONS=${inherited} MVK_CONFIG_LOG_LEVEL=MVK_CONFIG_LOG_LEVEL_NONE",
               "build"

    (libexec"lib").install Dir["ExternalbuildIntermediatesXCFrameworkStagingRelease" \
                                "Platformlib{SPIRVCross,SPIRVTools,glslang}.a"]
    glslang_dir = Pathname.new("Externalglslang")
    Pathname.glob("Externalglslang{glslang,SPIRV}***.{h,hpp}") do |header|
      header.chmod 0644
      (libexec"include"header.parent.relative_path_from(glslang_dir)).install header
    end
    (libexec"include").install "ExternalSPIRV-Crossincludespirv_cross"
    (libexec"include").install "ExternalglslangExternalspirv-toolsincludespirv-tools"
    (libexec"include").install "ExternalVulkan-Headersincludevulkan" => "vulkan"
    (libexec"include").install "ExternalVulkan-Headersincludevk_video" => "vk_video"

    frameworks.install "PackageReleaseMoltenVKMoltenVK.xcframework"
    lib.install "PackageReleaseMoltenVKdylibmacOSlibMoltenVK.dylib"
    lib.install "buildReleaselibMoltenVK.a"
    include.install "MoltenVKMoltenVKAPI" => "MoltenVK"

    bin.install "PackageReleaseMoltenVKShaderConverterToolsMoltenVKShaderConverter"
    frameworks.install "PackageReleaseMoltenVKShaderConverter" \
                       "MoltenVKShaderConverter.xcframework"
    include.install Dir["PackageReleaseMoltenVKShaderConverterinclude" \
                        "MoltenVKShaderConverter"]

    inreplace "MoltenVKicdMoltenVK_icd.json",
              ".libMoltenVK.dylib",
              (lib"libMoltenVK.dylib").relative_path_from(share"vulkanicd.d")
    (share"vulkan").install "MoltenVKicd" => "icd.d"
  end

  test do
    (testpath"test.cpp").write <<~EOS
      #include <vulkanvulkan.h>
      int main(void) {
        const char *extensionNames[] = { "VK_KHR_surface" };
        VkInstanceCreateInfo instanceCreateInfo = {
          VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO, NULL,
          0, NULL,
          0, NULL,
          1, extensionNames,
        };
        VkInstance inst;
        vkCreateInstance(&instanceCreateInfo, NULL, &inst);
        return 0;
      }
    EOS
    system ENV.cc, "-o", "test", "test.cpp", "-I#{include}", "-I#{libexec"include"}", "-L#{lib}", "-lMoltenVK"
    system ".test"
  end
end