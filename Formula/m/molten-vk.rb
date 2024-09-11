class MoltenVk < Formula
  desc "Implementation of the Vulkan graphics and compute API on top of Metal"
  homepage "https:github.comKhronosGroupMoltenVK"
  license "Apache-2.0"

  stable do
    url "https:github.comKhronosGroupMoltenVKarchiverefstagsv1.2.10.tar.gz"
    sha256 "3435d34ea2dafb043dd82ac5e9d2de7090462ab7cea6ad8bcc14d9c34ff99e9c"

    # MoltenVK depends on very specific revisions of its dependencies.
    # For each resource the path to the file describing the expected
    # revision is listed.
    resource "SPIRV-Cross" do
      # ExternalRevisionsSPIRV-Cross_repo_revision
      url "https:github.comKhronosGroupSPIRV-Cross.git",
          revision: "68d401117c85219ee6b2aba9a0cded314c55798f"
    end

    resource "Vulkan-Headers" do
      # ExternalRevisionsVulkan-Headers_repo_revision
      url "https:github.comKhronosGroupVulkan-Headers.git",
          revision: "fc6c06ac529e4b4b6e34c17cc650a8f62dee2eb0"
    end

    resource "Vulkan-Tools" do
      # ExternalRevisionsVulkan-Tools_repo_revision
      url "https:github.comKhronosGroupVulkan-Tools.git",
          revision: "b47676a03827fc0c287409b243b1fd62886e79c0"
    end

    resource "cereal" do
      # ExternalRevisionscereal_repo_revision
      url "https:github.comUSCiLabcereal.git",
          revision: "51cbda5f30e56c801c07fe3d3aba5d7fb9e6cca4"
    end

    resource "glslang" do
      # ExternalRevisionsglslang_repo_revision
      url "https:github.comKhronosGroupglslang.git",
          revision: "fa9c3deb49e035a8abcabe366f26aac010f6cbfb"
    end

    resource "SPIRV-Tools" do
      # known_good.json in the glslang repository at revision of resource above
      url "https:github.comKhronosGroupSPIRV-Tools.git",
          revision: "0cfe9e7219148716dfd30b37f4d21753f098707a"
    end

    resource "SPIRV-Headers" do
      # known_good.json in the glslang repository at revision of resource above
      url "https:github.comKhronosGroupSPIRV-Headers.git",
          revision: "2acb319af38d43be3ea76bfabf3998e5281d8d12"
    end
  end

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia:  "59b4dd145cf7f5807460cecbcee7a97c4fd2906013412e25968cdf431f6988c6"
    sha256 cellar: :any, arm64_sonoma:   "25a56ad433bb2d345a836eda1cc7063b7cac29e09f147e55cd3e1a04d45999ec"
    sha256 cellar: :any, arm64_ventura:  "521089ebcb007b928c6fe5dc73ae9f81d3f50c1bb02765ba49d23feca8beb3ba"
    sha256 cellar: :any, arm64_monterey: "698a475e905947cb6664e91cf763fe0ced69429fd4a1608a0b0cd119d6370405"
    sha256 cellar: :any, sonoma:         "1b064d8edaf38568f00197e8a6245216d633ee818adf9d589d5c71c4b0dbdfe9"
    sha256 cellar: :any, ventura:        "967bdf7e10ad32783d9a61efc94f109fcee621270a47f9c9f3717489d02cdaf9"
    sha256 cellar: :any, monterey:       "f6c81b510db91bc3ee5f68281a803b1913596b7c40db24d8e472af0aa988070a"
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