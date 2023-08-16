class Xcodegen < Formula
  desc "Generate your Xcode project from a spec file and your folder structure"
  homepage "https://github.com/yonaskolb/XcodeGen"
  url "https://ghproxy.com/https://github.com/yonaskolb/XcodeGen/archive/2.36.1.tar.gz"
  sha256 "780679512ce87c393c4b7ac9345962babde34cc7f3d4b9078474dd5c7639f64a"
  license "MIT"
  head "https://github.com/yonaskolb/XcodeGen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "12b1320bab438cbd448699463bf2bb9b6869fe99070d42c8c3b888788bda8dcc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37a7029ac73b043b71040c38dceaf1baa966f24890e4bbb0290c29a2010875e8"
    sha256 cellar: :any_skip_relocation, ventura:        "360f6df7a49c2b9faba923afcc776133d029ae523d7e2d4cb5c8ca437b316eee"
    sha256 cellar: :any_skip_relocation, monterey:       "0bfb411442ebbec7cb2142c8dce875f758f53fed02bd50c51b8a5be76391017f"
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