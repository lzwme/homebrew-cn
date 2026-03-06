class Xcodegen < Formula
  desc "Generate your Xcode project from a spec file and your folder structure"
  homepage "https://github.com/yonaskolb/XcodeGen"
  url "https://ghfast.top/https://github.com/yonaskolb/XcodeGen/archive/refs/tags/2.45.2.tar.gz"
  sha256 "a99488fdcfe3a09b253283103e4e9e9d6d084e9836ce72d8fd9b8bfd040ba83a"
  license "MIT"
  head "https://github.com/yonaskolb/XcodeGen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be540103642953a6c187d281838114d8b784a09169e15fc8e85bcc4a3f586074"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e60de388515ace5c03163ff97626a5b732e9e7632ab5ef0be85f5a3798aced0f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9d0d269b7b374deeaed12d3afa9b4591e57f27eac7ba1841ed2b7d525c36867"
    sha256 cellar: :any_skip_relocation, sonoma:        "08488a05c4ef706ffdf14620b7b01969706394d9416786137aa1361fab079d04"
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