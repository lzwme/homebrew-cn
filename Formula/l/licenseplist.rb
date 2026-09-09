class Licenseplist < Formula
  desc "License list generator of all your dependencies for iOS applications"
  homepage "https://www.slideshare.net/mono0926/licenseplist-a-license-list-generator-of-all-your-dependencies-for-ios-applications"
  url "https://ghfast.top/https://github.com/mono0926/LicensePlist/archive/refs/tags/3.28.1.tar.gz"
  sha256 "22d314762343cc3a93265b66bc1d39f3c6a1b6a4be2f250b5dcd2815b2db6a3b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ebbf9914a8d3bbb7e26402146e8bdd40afdb06e96c4fcb5e2021aa809468819"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "484d121cf1dc55edb596f629f8c4106643ef57d44936ea6c5db31ff73214707d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5fc39108fe8afb861e52610df295ed5328443802f9b1e6376f0987385825007"
  end

  depends_on :macos

  uses_from_macos "swift" => :build, since: :sonoma # swift 6.0+

  def install
    system "swift", "build", *std_swift_args
    bin.install ".build/release/license-plist"
    generate_completions_from_executable(bin/"license-plist", "--generate-completion-script")
  end

  test do
    (testpath/"Cartfile.resolved").write <<~EOS
      github "realm/realm-swift" "v10.20.2"
    EOS
    assert_match "None", shell_output("#{bin}/license-plist --suppress-opening-directory")
  end
end