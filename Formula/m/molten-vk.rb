class MoltenVk < Formula
  desc "Implementation of the Vulkan graphics and compute API on top of Metal"
  homepage "https:github.comKhronosGroupMoltenVK"
  license "Apache-2.0"

  stable do
    url "https:github.comKhronosGroupMoltenVKarchiverefstagsv1.2.7.tar.gz"
    sha256 "3166edcfdca886b4be1a24a3c140f11f9a9e8e49878ea999e3580dfbf9fe4bec"

    # MoltenVK depends on very specific revisions of its dependencies.
    # For each resource the path to the file describing the expected
    # revision is listed.
    resource "SPIRV-Cross" do
      # ExternalRevisionsSPIRV-Cross_repo_revision
      url "https:github.comKhronosGroupSPIRV-Cross.git",
          revision: "117161dd546075a568f0526bccffcd7e0bc96897"
    end

    resource "Vulkan-Headers" do
      # ExternalRevisionsVulkan-Headers_repo_revision
      url "https:github.comKhronosGroupVulkan-Headers.git",
          revision: "217e93c664ec6704ec2d8c36fa116c1a4a1e2d40"
    end

    resource "Vulkan-Tools" do
      # ExternalRevisionsVulkan-Tools_repo_revision
      url "https:github.comKhronosGroupVulkan-Tools.git",
          revision: "2c0a644db855f40f100f9f39e5a8a8dfa2b0014d"
    end

    resource "cereal" do
      # ExternalRevisionscereal_repo_revision
      url "https:github.comUSCiLabcereal.git",
          revision: "51cbda5f30e56c801c07fe3d3aba5d7fb9e6cca4"
    end

    resource "glslang" do
      # ExternalRevisionsglslang_repo_revision
      url "https:github.comKhronosGroupglslang.git",
          revision: "a91631b260cba3f22858d6c6827511e636c2458a"
    end

    resource "SPIRV-Tools" do
      # known_good.json in the glslang repository at revision of resource above
      url "https:github.comKhronosGroupSPIRV-Tools.git",
          revision: "f0cc85efdbbe3a46eae90e0f915dc1509836d0fc"
    end

    resource "SPIRV-Headers" do
      # known_good.json in the glslang repository at revision of resource above
      url "https:github.comKhronosGroupSPIRV-Headers.git",
          revision: "1c6bb2743599e6eb6f37b2969acc0aef812e32e3"
    end
  end

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "d5c9c58fb6e8ade6c059a4f8584b4cfb9b77e6d93a6c46856c9c61d72a827b92"
    sha256 cellar: :any, arm64_ventura:  "d5c9c58fb6e8ade6c059a4f8584b4cfb9b77e6d93a6c46856c9c61d72a827b92"
    sha256 cellar: :any, arm64_monterey: "3cebad86a5ed6dbbfb8585c3d53a3b231daf0920d1e828b25d70f96f0739fd0f"
    sha256 cellar: :any, sonoma:         "e71d24f1f20db3dae42699531bf49cf656f533f03291616179f21f99a32680e5"
    sha256 cellar: :any, ventura:        "e71d24f1f20db3dae42699531bf49cf656f533f03291616179f21f99a32680e5"
    sha256 cellar: :any, monterey:       "8830b328d1ce651e6f9ef1be8b85f01c955f055eb0b5c386786a865054d9e0ec"
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
  depends_on xcode: ["11.7", :build]
  # Requires IOSurfaceIOSurfaceRef.h.
  depends_on macos: :sierra
  depends_on :macos # Linux does not have a Metal implementation. Not implied by the line above.

  uses_from_macos "python" => :build, since: :catalina

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
                "-library", ".ExternalbuildReleaselibSPIRVCross.a"
      xcodebuild "-create-xcframework", "-output", ".ExternalbuildReleaseSPIRVTools.xcframework",
                "-library", ".ExternalbuildReleaselibSPIRVTools.a"
      xcodebuild "-create-xcframework", "-output", ".ExternalbuildReleaseglslang.xcframework",
                "-library", ".ExternalbuildReleaselibglslang.a"
    end

    # Build MoltenVK Package
    xcodebuild "ARCHS=#{Hardware::CPU.arch}", "ONLY_ACTIVE_ARCH=YES",
               "-project", "MoltenVKPackaging.xcodeproj",
               "-scheme", "MoltenVK Package (macOS only)",
               "-derivedDataPath", "#{buildpath}build",
               "SYMROOT=#{buildpath}build", "OBJROOT=build",
               "GCC_PREPROCESSOR_DEFINITIONS=${inherited} MVK_CONFIG_LOG_LEVEL=MVK_CONFIG_LOG_LEVEL_NONE",
               "build"

    (libexec"lib").install Dir["ExternalbuildRelease" \
                                "lib{SPIRVCross,SPIRVTools,glslang}.a"]
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