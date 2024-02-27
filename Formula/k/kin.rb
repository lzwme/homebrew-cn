class Kin < Formula
  include Language::Python::Virtualenv

  desc "Sane PBXProj files"
  homepage "https:github.comSerchinasticoKin"
  url "https:files.pythonhosted.orgpackagesaba6fe193e6193675c978b493ebe8e6a606b52203e37463179ca573ebcaa18ddkin-2.1.9.tar.gz"
  sha256 "35da507e45b733a6f391676b47995b26ca40afcb38fcb5c3f5e0d90101027dee"
  license "Apache-2.0"
  head "https:github.comSerchinasticoKin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "72ceb288c7ec1f5669544fe6ab9aeba9bef50a7b9153de7d6494c74aff6f49c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c4e3aa72276f7639f716e38f87edca546be48f8c76da97b50a5c8f805f60196"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9eb6bc7b4d86f5e2c689a797f1e307a7e87567524b4075163c96fc17f422c8a6"
    sha256 cellar: :any_skip_relocation, sonoma:         "f7ae3e2e893df9fb31087548f90fbd0fe792aa2b38cc9b9c230841a82a5f3b8d"
    sha256 cellar: :any_skip_relocation, ventura:        "4e661f1ce7e41a958b76a6743521e4e44f7b69d7d2df17af524cd8d3ad68dc8e"
    sha256 cellar: :any_skip_relocation, monterey:       "46bf71970fe31abe368abe43652e8639c9dd04ea69fafa4ca3121eaded9b3909"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7b046a13badece5223b6b62513db9ac7a0da3c41e3ba47c4cce4e52b2c0ba33"
  end

  depends_on "python@3.12"

  resource "antlr4-python3-runtime" do
    url "https:files.pythonhosted.orgpackagesb6007f1cab9b44518ca225a03f4493ac9294aab5935a7a28486ba91a20ea29cfantlr4-python3-runtime-4.13.1.tar.gz"
    sha256 "3cd282f5ea7cfb841537fe01f143350fdb1c0b1ce7981443a2fa8513fddb6d1a"
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