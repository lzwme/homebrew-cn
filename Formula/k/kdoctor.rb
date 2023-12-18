class Kdoctor < Formula
  desc "Environment diagnostics for Kotlin Multiplatform Mobile app development"
  homepage "https:github.comkotlinkdoctor"
  url "https:github.comKotlinkdoctorarchiverefstagsv1.1.0.tar.gz"
  sha256 "d0c8cfeb84c49f98e0069aff55897ebdd5b79e6fc2f52744659377732769c7b9"
  license "Apache-2.0"
  head "https:github.comKotlinkdoctor.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ae7b5e68925f38cb7ba4dbe3503da29bffa7b863afb2062cc1bd08b3ed119627"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2bb2c0149a4c88f6e80b7431d5a2bb8a4552a36524127976091655a678cccdd4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "243b8e7f3d9e352eea87a69763ae977a27fd109bbd3d092190ce8080d469f70b"
    sha256 cellar: :any_skip_relocation, sonoma:         "1109e4a03e28acc679a4816ae81348af33609ed2304d2fed74d8b331e58b4601"
    sha256 cellar: :any_skip_relocation, ventura:        "a83d0b999afc56ea71f884bf7d23e54cd5b96d5b8ce13e1183fd16616510a0a7"
    sha256 cellar: :any_skip_relocation, monterey:       "e2ad6b016b9f6ca3904aa6a08c2b98f873836f7b55dfe22706b6657e2a480002"
  end

  depends_on "gradle" => :build
  depends_on "openjdk" => :build
  depends_on xcode: ["12.5", :build]
  depends_on :macos

  def install
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix
    mac_suffix = Hardware::CPU.intel? ? "X64" : Hardware::CPU.arch.to_s.capitalize
    build_task = "linkReleaseExecutableMacos#{mac_suffix}"
    system "gradle", "clean", build_task
    bin.install "kdoctorbuildbinmacos#{mac_suffix}releaseExecutablekdoctor.kexe" => "kdoctor"
  end

  test do
    output = shell_output("#{bin}kdoctor --team-ids")
    assert_match "Certificates are not found", output

    output = shell_output(bin"kdoctor")
    assert_match "System", output
    assert_match "Java", output
    assert_match "Android Studio", output
    assert_match "Xcode", output
    assert_match "CocoaPods", output

    assert_match version.to_s, shell_output("#{bin}kdoctor --version")
  end
end