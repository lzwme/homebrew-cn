class Xcodegen < Formula
  desc "Generate your Xcode project from a spec file and your folder structure"
  homepage "https://github.com/yonaskolb/XcodeGen"
  url "https://ghfast.top/https://github.com/yonaskolb/XcodeGen/archive/refs/tags/2.44.0.tar.gz"
  sha256 "dbf90102f66891f3236250a19a5208524e6905323dd56f770dd65dc5a007a7e7"
  license "MIT"
  head "https://github.com/yonaskolb/XcodeGen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0969ab361e69266f4b94cf03d76cd5162229834cdeb8ae495982656b053e3305"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e28672609ead1d40b700e00d016cba2decfefbd1fa1adc65befcc26dc2b86047"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2aea175c36ddc40de4155c8f83f2b10d88fb21426a41a07cd86a0b87aab2cd2"
  end

  depends_on xcode: ["15.3", :build]
  depends_on :macos

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/#{name}"
    pkgshare.install "SettingPresets"
  end

  test do
    (testpath/"xcodegen.yml").write <<~YAML
      name: GeneratedProject
      options:
        bundleIdPrefix: com.project
      targets:
        TestProject:
          type: application
          platform: iOS
          sources: TestProject
    YAML
    (testpath/"TestProject").mkpath
    system bin/"xcodegen", "--spec", testpath/"xcodegen.yml"
    assert_path_exists testpath/"GeneratedProject.xcodeproj"
    assert_path_exists testpath/"GeneratedProject.xcodeproj/project.pbxproj"
    output = (testpath/"GeneratedProject.xcodeproj/project.pbxproj").read
    assert_match "name = TestProject", output
    assert_match "isa = PBXNativeTarget", output
  end
end