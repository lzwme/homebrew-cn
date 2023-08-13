class Xcodegen < Formula
  desc "Generate your Xcode project from a spec file and your folder structure"
  homepage "https://github.com/yonaskolb/XcodeGen"
  url "https://ghproxy.com/https://github.com/yonaskolb/XcodeGen/archive/2.36.0.tar.gz"
  sha256 "d1d275a24bd96e34f2a55676af03b6e6d06d903dcd632c36bea6e928c3fd2cd8"
  license "MIT"
  head "https://github.com/yonaskolb/XcodeGen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e8eb459b48df7fc669faf73b4d7763826a5da94674d77a968de42878a0f7e2e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc574b65a687f0fb10ad6053cb0b6b6585174ca4947484b73f18372884257a33"
    sha256 cellar: :any_skip_relocation, ventura:        "ae108f582123876cb8008391831ca0e0dba010650113596857b74c1af481f62b"
    sha256 cellar: :any_skip_relocation, monterey:       "4437dfe6e20a2f9627fb8ab739addefd67a6c1f0c20bae731cd69fdf95b738d5"
  end

  depends_on xcode: ["14.0", :build]
  depends_on :macos

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/#{name}"
    pkgshare.install "SettingPresets"
  end

  test do
    (testpath/"xcodegen.yml").write <<~EOS
      name: GeneratedProject
      options:
        bundleIdPrefix: com.project
      targets:
        TestProject:
          type: application
          platform: iOS
          sources: TestProject
    EOS
    (testpath/"TestProject").mkpath
    system bin/"xcodegen", "--spec", testpath/"xcodegen.yml"
    assert_predicate testpath/"GeneratedProject.xcodeproj", :exist?
    assert_predicate testpath/"GeneratedProject.xcodeproj/project.pbxproj", :exist?
    output = (testpath/"GeneratedProject.xcodeproj/project.pbxproj").read
    assert_match "name = TestProject", output
    assert_match "isa = PBXNativeTarget", output
  end
end