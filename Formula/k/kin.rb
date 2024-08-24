class Kin < Formula
  include Language::Python::Virtualenv

  desc "Sane PBXProj files"
  homepage "https:github.comSerchinasticoKin"
  url "https:files.pythonhosted.orgpackages4f36dcb0e16c5634d58d0ef2f771fe1e608264698394f4a184afc289d9a85bb8kin-2.1.10.tar.gz"
  sha256 "a3cbb3b376c3d28b16b0c07ee835607690745b7a3ba7592f2534b384dd9a9eab"
  license "Apache-2.0"
  head "https:github.comSerchinasticoKin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ea242d6c5242419942c7fcf8b3efaeee56d9a599d8a81b1f6d2898da975f6350"
  end

  depends_on "python@3.12"

  resource "antlr4-python3-runtime" do
    url "https:files.pythonhosted.orgpackagesb6007f1cab9b44518ca225a03f4493ac9294aab5935a7a28486ba91a20ea29cfantlr4-python3-runtime-4.13.1.tar.gz"
    sha256 "3cd282f5ea7cfb841537fe01f143350fdb1c0b1ce7981443a2fa8513fddb6d1a"
  end

  # Drop unneeded argparse requirement: https:github.comSerchinasticoKinpull115
  patch do
    url "https:github.comSerchinasticoKincommit02251e6babc56e3b3d5dfda18559d2f86f147975.patch?full_index=1"
    sha256 "838b4e9fe54c9afcff0f38a6b6f1eda83883ff724c7089bfa08521f96615fbca"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath"Good.xcodeprojproject.pbxproj").write <<~EOS
      {
        archiveVersion = 1;
        classes = {};
        objectVersion = 46;
        objects = {
          FE870E28DC2371E7ACA886F03F460581 = {isa = PBXFileReference; explicitFileType = text.xcconfig; name = "Something.xcconfig"; path = "ConfigurationsSomething.xcconfig"; sourceTree = "<group>"; };
          78452DDA02BFEF5D6BA29AEFB4B1266A = {isa = PBXGroup; children = (FE870E28DC2371E7ACA886F03F460581,); name = Configurations; sourceTree = "<group>"; };
          49FBBF861C10C2A200A1A4BB = {isa = PBXProject; buildConfigurationList = 49FBBF891C10C2A200A1A4BB; compatibilityVersion = "Xcode 3.2"; hasScannedForEncodings = 0; mainGroup = 49FBBF851C10C2A200A1A4BB; productRefGroup = 49FBBF8F1C10C2A200A1A4BB; projectDirPath = ""; projectRoot = ""; targets = (49FBBF8D1C10C2A200A1A4BB, 4973659B1C19BC6E00837617,); };
          49FBBF951C10C2A200A1A4BB = {isa = PBXVariantGroup; children = (49FBBF961C10C2A200A1A4BB,); name = Main.storyboard; sourceTree = "<group>"; };
          49FBBF9A1C10C2A200A1A4BB = {isa = PBXVariantGroup; children = (49FBBF9B1C10C2A200A1A4BB,); name = LaunchScreen.storyboard; sourceTree = "<group>"; };
          497365A41C19BC6E00837617 = {isa = XCBuildConfiguration; baseConfigurationReference = 274E42B0193BA6FEFA8FD71C; buildSettings = { FRAMEWORK_SEARCH_PATHS = ("$(inherited)", "$(PROJECT_DIR)buildDebug-iphoneos",); }; name = Debug; };
          49FBBFB61C10C2A200A1A4BB = {isa = XCConfigurationList; buildConfigurations = (49FBBFB71C10C2A200A1A4BB, 49FBBFB81C10C2A200A1A4BB,); defaultConfigurationIsVisible = 0; defaultConfigurationName = Release; };
        };
        rootObject = 49FBBF861C10C2A200A1A4BB;
      }
    EOS
    output = shell_output("#{bin}kin Good.xcodeprojproject.pbxproj")
    assert_match output, "CORRECT\n"
  end
end