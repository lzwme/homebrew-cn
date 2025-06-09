class MoltenVk < Formula
  desc "Implementation of the Vulkan graphics and compute API on top of Metal"
  homepage "https:github.comKhronosGroupMoltenVK"
  license "Apache-2.0"

  stable do
    url "https:github.comKhronosGroupMoltenVKarchiverefstagsv1.3.0.tar.gz"
    sha256 "9476033d49ef02776ebab288fffae3e28fd627a3e29b7ae5975a1e1c785bf912"

    # MoltenVK depends on very specific revisions of its dependencies.
    # For each resource the path to the file describing the expected
    # revision is listed.
    resource "SPIRV-Cross" do
      # ExternalRevisionsSPIRV-Cross_repo_revision
      url "https:github.comKhronosGroupSPIRV-Cross.git",
          revision: "7918775748c5e2f5c40d9918ce68825035b5a1e1"
    end

    resource "SPIRV-Headers" do
      # ExternalRevisionsSPIRV-Headers_repo_revision
      url "https:github.comKhronosGroupSPIRV-Headers.git",
          revision: "bab63ff679c41eb75fc67dac76e1dc44426101e1"
    end

    resource "SPIRV-Tools" do
      # ExternalRevisionsSPIRV-Tools_repo_revision
      url "https:github.comKhronosGroupSPIRV-Tools.git",
          revision: "783d7033613cedaa7147d0700b517abc5c32312d"
    end

    resource "Vulkan-Headers" do
      # ExternalRevisionsVulkan-Headers_repo_revision
      url "https:github.comKhronosGroupVulkan-Headers.git",
          revision: "e2e53a724677f6eba8ff0ce1ccb64ee321785cbd"
    end

    resource "Vulkan-Tools" do
      # ExternalRevisionsVulkan-Tools_repo_revision
      url "https:github.comKhronosGroupVulkan-Tools.git",
          revision: "682e42f7ae70a8fadf374199c02de737daa5c70d"
    end

    resource "cereal" do
      # ExternalRevisionscereal_repo_revision
      url "https:github.comUSCiLabcereal.git",
          revision: "51cbda5f30e56c801c07fe3d3aba5d7fb9e6cca4"
    end
  end

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any, arm64_sequoia: "4994cc7e6e7f8af2fb2898fb4d8f806f55ff064d6249beca4ab2f208fd5de319"
    sha256 cellar: :any, arm64_sonoma:  "c7b7d5d02a925546a6e0cc0c4187fe0b643731abbb32b590a4e60906f688046f"
    sha256 cellar: :any, arm64_ventura: "cf825bb401b89d746b3fd1274a839e61e15aa4a8fa0c7f327db2b1d4e14fe334"
    sha256 cellar: :any, sonoma:        "e208e8fe6f90aecc6a16bb3f883cb56f4da55d1b04daae6794f70ace0d835f57"
    sha256 cellar: :any, ventura:       "b2e3d1f9dc95f2d45b3f25483bf75bc014950b61a830768615a130111bbaa6f5"
  end

  head do
    url "https:github.comKhronosGroupMoltenVK.git", branch: "main"

    resource "SPIRV-Cross" do
      url "https:github.comKhronosGroupSPIRV-Cross.git", branch: "main"
    end

    resource "SPIRV-Headers" do
      url "https:github.comKhronosGroupSPIRV-Headers.git", branch: "main"
    end

    resource "SPIRV-Tools" do
      url "https:github.comKhronosGroupSPIRV-Tools.git", branch: "main"
    end

    resource "Vulkan-Headers" do
      url "https:github.comKhronosGroupVulkan-Headers.git", branch: "main"
    end

    resource "Vulkan-Tools" do
      url "https:github.comKhronosGroupVulkan-Tools.git", branch: "main"
    end

    resource "cereal" do
      url "https:github.comUSCiLabcereal.git", branch: "master"
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

    # Build spirv-tools
    mv "ExternalSPIRV-Headers", "Externalspirv-toolsexternalspirv-headers"

    mkdir "Externalspirv-tools" do
      system "cmake", "-S", ".", "-B", "build", *std_cmake_args
      system "cmake", "--build", "build"
    end

    # Build ExternalDependencies
    xcodebuild "ARCHS=#{Hardware::CPU.arch}", "ONLY_ACTIVE_ARCH=YES",
               "-project", "ExternalDependencies.xcodeproj",
               "-scheme", "ExternalDependencies-macOS",
               "-derivedDataPath", "Externalbuild",
               "SYMROOT=Externalbuild", "OBJROOT=Externalbuild",
               "build"

    if DevelopmentTools.clang_build_version >= 1500 && MacOS.version < :sonoma
      # Required to build xcframeworks with Xcode 15
      # https:github.comKhronosGroupMoltenVKissues2028
      xcodebuild "-create-xcframework", "-output", ".ExternalbuildReleaseSPIRVCross.xcframework",
                "-library", ".ExternalbuildReleaselibSPIRVCross.a"
      xcodebuild "-create-xcframework", "-output", ".ExternalbuildReleaseSPIRVTools.xcframework",
                "-library", ".ExternalbuildReleaselibSPIRVTools.a"
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
                                "lib{SPIRVCross,SPIRVTools}.a"]

    (libexec"include").install "ExternalSPIRV-Crossincludespirv_cross"
    (libexec"include").install "ExternalSPIRV-Toolsincludespirv-tools"
    (libexec"include").install "ExternalVulkan-Headersincludevulkan" => "vulkan"
    (libexec"include").install "ExternalVulkan-Headersincludevk_video" => "vk_video"

    frameworks.install "PackageReleaseMoltenVKstaticMoltenVK.xcframework"
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
              (lib"libMoltenVK.dylib").relative_path_from(prefix"etcvulkanicd.d")
    (prefix"etcvulkan").install "MoltenVKicd" => "icd.d"
  end

  test do
    (testpath"test.cpp").write <<~CPP
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
    CPP
    system ENV.cc, "-o", "test", "test.cpp", "-I#{include}", "-I#{libexec"include"}", "-L#{lib}", "-lMoltenVK"
    system ".test"
  end
end