class Kin < Formula
  include Language::Python::Virtualenv

  desc "Sane PBXProj files"
  homepage "https:github.comSerchinasticoKin"
  url "https:files.pythonhosted.orgpackages824504e43dc1764897bf6c9a30386db64d3732cfdbda5ceb75ce9cbcb12c90d1kin-2.1.7.tar.gz"
  sha256 "d71146b99e18ece9546c0677a8fa8b21c7c777e86ef007c2fea77074254d2ba6"
  license "Apache-2.0"
  head "https:github.comSerchinasticoKin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6807d8dd5eb1f09a09a71a785fcaa8f45f35b9d0947f2940a1beb10a48f93a36"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "06ab8e57893078fb0792bffc354312e94c353e37ac8ca6532135e9ad7d975aba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "818558a3eda35af74a418207556a8ff0b7fb24249c0f0e9b79d89319a4b23aec"
    sha256 cellar: :any_skip_relocation, sonoma:         "c1084bb9a1381fa05866c7cfd81271c18bc8a7ff0c877f133fef3f31bcb245ec"
    sha256 cellar: :any_skip_relocation, ventura:        "155712f579dd6161db9bedf3deffd586502a9276a0940df07ad40fdac3f597a2"
    sha256 cellar: :any_skip_relocation, monterey:       "e505a49dbaefe2d93f5ba153f6156a2d07cd62c47ac83c32acf19cd933b00d09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0328c3668c00292fb9736cfc30cbb74259201456f9230fa2f2ae9572901bcfd3"
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