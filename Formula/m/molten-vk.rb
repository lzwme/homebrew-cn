class MoltenVk < Formula
  desc "Implementation of the Vulkan graphics and compute API on top of Metal"
  homepage "https:github.comKhronosGroupMoltenVK"
  license "Apache-2.0"

  stable do
    url "https:github.comKhronosGroupMoltenVKarchiverefstagsv1.2.11.tar.gz"
    sha256 "bfa115e283831e52d70ee5e13adf4d152de8f0045996cf2a33f0ac541be238b1"

    # MoltenVK depends on very specific revisions of its dependencies.
    # For each resource the path to the file describing the expected
    # revision is listed.
    resource "SPIRV-Cross" do
      # ExternalRevisionsSPIRV-Cross_repo_revision
      url "https:github.comKhronosGroupSPIRV-Cross.git",
          revision: "65d7393430f6c7bb0c20b6d53250fe04847cc2ae"
    end

    resource "Vulkan-Headers" do
      # ExternalRevisionsVulkan-Headers_repo_revision
      url "https:github.comKhronosGroupVulkan-Headers.git",
          revision: "29f979ee5aa58b7b005f805ea8df7a855c39ff37"
    end

    resource "Vulkan-Tools" do
      # ExternalRevisionsVulkan-Tools_repo_revision
      url "https:github.comKhronosGroupVulkan-Tools.git",
          revision: "2020cec4111c87d85b167d583180b839f0c736c5"
    end

    resource "cereal" do
      # ExternalRevisionscereal_repo_revision
      url "https:github.comUSCiLabcereal.git",
          revision: "51cbda5f30e56c801c07fe3d3aba5d7fb9e6cca4"
    end

    resource "glslang" do
      # ExternalRevisionsglslang_repo_revision
      url "https:github.comKhronosGroupglslang.git",
          revision: "46ef757e048e760b46601e6e77ae0cb72c97bd2f"
    end

    resource "SPIRV-Tools" do
      # known_good.json in the glslang repository at revision of resource above
      url "https:github.comKhronosGroupSPIRV-Tools.git",
          revision: "6dcc7e350a0b9871a825414d42329e44b0eb8109"
    end

    resource "SPIRV-Headers" do
      # known_good.json in the glslang repository at revision of resource above
      url "https:github.comKhronosGroupSPIRV-Headers.git",
          revision: "2a9b6f951c7d6b04b6c21fe1bf3f475b68b84801"
    end
  end

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_sequoia: "306fb6df9ca047fbf61e46b82ae3a3cd9f4fe8c60a236c4940e460f9a42ae169"
    sha256 cellar: :any, arm64_sonoma:  "36a99f13dd4317c01f7e0024c4bc346c5d3a66084bc8ed1c5e5a20948cd89b2d"
    sha256 cellar: :any, arm64_ventura: "b39bdae032fa33dfb52e870fbce6b5a75801f8b954a5edeab1f0fa42a3fb0fc2"
    sha256 cellar: :any, sonoma:        "dcf6fca1aee3f565b9806c0f9586312b0d2f7c0268ba10095dfe0ace8416cf64"
    sha256 cellar: :any, ventura:       "d229ac36b1021d4d32c347bbd6dcdbed33b2ed54f10b8ef14fb95586c086fbde"
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

    if DevelopmentTools.clang_build_version >= 1500 && MacOS.version < :sonoma
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