class Xcodegen < Formula
  desc "Generate your Xcode project from a spec file and your folder structure"
  homepage "https:github.comyonaskolbXcodeGen"
  url "https:github.comyonaskolbXcodeGenarchiverefstags2.40.0.tar.gz"
  sha256 "de10a46932e1d18fd01f012e9b441f997ca4b6115bfcf5c0d82259c4f0c2cdbe"
  license "MIT"
  head "https:github.comyonaskolbXcodeGen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "45b21e4752c6dd2209fc61e4ae68715f563b5472e8febb0b6b333cdf2d45b03c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d50792a39a414bcdefacd54110490bf191feb9e79decedb2b7fc45f93c2ffa6a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "054a6a2c0cad4b3d91746aac21307fa23e6ebd4472e374a620d37c1d52aa51a2"
    sha256 cellar: :any_skip_relocation, sonoma:         "6659ab6ec4c24362dbcbca883fbb7e3597eafa3a6d2b8bef4aee55dcff7803fa"
    sha256 cellar: :any_skip_relocation, ventura:        "e53afd0a57edad23ab596eee0208885677e6271b4bfa2d3acc781eba86c24070"
    sha256 cellar: :any_skip_relocation, monterey:       "38cd7f162ed91a65978d1e003f3bf7eba255b56352163587cdb414e3a4ab4964"
  end

  depends_on xcode: ["14.0", :build]
  depends_on :macos

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".buildrelease#{name}"
    pkgshare.install "SettingPresets"
  end

  test do
    (testpath"xcodegen.yml").write <<~EOS
      name: GeneratedProject
      options:
        bundleIdPrefix: com.project
      targets:
        TestProject:
          type: application
          platform: iOS
          sources: TestProject
    EOS
    (testpath"TestProject").mkpath
    system bin"xcodegen", "--spec", testpath"xcodegen.yml"
    assert_predicate testpath"GeneratedProject.xcodeproj", :exist?
    assert_predicate testpath"GeneratedProject.xcodeprojproject.pbxproj", :exist?
    output = (testpath"GeneratedProject.xcodeprojproject.pbxproj").read
    assert_match "name = TestProject", output
    assert_match "isa = PBXNativeTarget", output
  end
end