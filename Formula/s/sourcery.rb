class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https:github.comkrzysztofzablockiSourcery"
  url "https:github.comkrzysztofzablockiSourceryarchiverefstags2.2.2.tar.gz"
  sha256 "98a3e700e61b3f1300afc5252c58a8703606915b8f3bf56af8bc886daee9feaa"
  license "MIT"
  version_scheme 1
  head "https:github.comkrzysztofzablockiSourcery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "091b282619acfa092ff3462c6a308c91f72a4ad1f42e384f176feaeac81e8048"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "60e3c29bc3de8abfdbe5faff50fb9a97396322a8a7330c33d678fbe41b652c7c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e42f490aac540d541781cb98f0dff983aa933850e06112b9374dcc0a21f567e"
    sha256 cellar: :any_skip_relocation, ventura:       "ff399487bcd3c35fc4186a9c084cb3d2a5a9980fbcab91cfcd9158227f85e264"
    sha256                               x86_64_linux:  "8227dac24b7f886ddadda5edd3ff4e33299d6f6d00773d74c1da7883e1a2769d"
  end

  depends_on xcode: "14.3"

  uses_from_macos "ruby" => :build
  uses_from_macos "sqlite"
  uses_from_macos "swift"

  def install
    system "rake", "build"
    bin.install "clibinsourcery"
    lib.install Dir["clilib*.dylib"]
  end

  test do
    # Regular functionality requires a non-sandboxed environment, so we can only test versionhelp here.
    assert_match version.to_s, shell_output("#{bin}sourcery --version").chomp
  end
end