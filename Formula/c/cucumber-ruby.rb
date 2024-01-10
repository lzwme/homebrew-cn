class CucumberRuby < Formula
  desc "Cucumber for Ruby"
  homepage "https:cucumber.io"
  url "https:github.comcucumbercucumber-rubyarchiverefstagsv9.1.1.tar.gz"
  sha256 "0ed71e206463b0deef9b50bfcbf611ec3efd2075aca93505559ed16670b39b79"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d362c1a29280c26292edbad4faddab87b8b3168d31ebb8a5737ab2661d94bf95"
    sha256 cellar: :any,                 arm64_ventura:  "ba0d5177f806fccc78550354bf1aabf7547c67bf928c24061cb14d732d05162a"
    sha256 cellar: :any,                 arm64_monterey: "d45bcb96da474809e10a53849d520e2098535a4209ef712bb017e2e5dcf44946"
    sha256 cellar: :any,                 sonoma:         "f41668fdb90f4eaf5de521871093b54aa351e006a9a2864d14a57f3c6d054671"
    sha256 cellar: :any,                 ventura:        "df7a97035d8e9ab3cb7f3b3665dc0637d18aefd8c42912f5f6b2ea6334550d4d"
    sha256 cellar: :any,                 monterey:       "95d87c9223a909c05e9050461b3f1081843fff00a14e6b6e31337a7e1889a8f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bac667fa09dd406d744c4d6e418be9f56291d571833f09c0cc513be369365af"
  end

  depends_on "pkg-config" => :build
  depends_on "ruby" # Requires >= Ruby 2.7

  uses_from_macos "libffi", since: :catalina

  # Runtime dependencies of cucumber
  # List with `gem install --explain cucumber`
  # https:rubygems.orggemscucumberversions9.0.1dependencies

  resource "ffi" do
    url "https:rubygems.orggemsffi-1.16.3.gem"
    sha256 "6d3242ff10c87271b0675c58d68d3f10148fabc2ad6da52a18123f06078871fb"
  end

  resource "sys-uname" do
    url "https:rubygems.orggemssys-uname-1.2.3.gem"
    sha256 "63c51d55180828c8e58847eb5c24934eed057f87fb016de6062aa11bf1c5490e"
  end

  resource "multi_test" do
    url "https:rubygems.orggemsmulti_test-1.1.0.gem"
    sha256 "e9e550cdd863fb72becfe344aefdcd4cbd26ebf307847f4a6c039a4082324d10"
  end

  resource "mini_mime" do
    url "https:rubygems.orggemsmini_mime-1.1.5.gem"
    sha256 "8681b7e2e4215f2a159f9400b5816d85e9d8c6c6b491e96a12797e798f8bccef"
  end

  resource "diff-lcs" do
    url "https:rubygems.orggemsdiff-lcs-1.5.0.gem"
    sha256 "49b934001c8c6aedb37ba19daec5c634da27b318a7a3c654ae979d6ba1929b67"
  end

  resource "cucumber-messages" do
    url "https:rubygems.orggemscucumber-messages-22.0.0.gem"
    sha256 "d08a6c228675dd036896bebe82a29750cbdc4dacd461e39edd1199dfa36da719"
  end

  resource "cucumber-html-formatter" do
    url "https:rubygems.orggemscucumber-html-formatter-21.2.0.gem"
    sha256 "4ee4f8d5dfe9477ec18afa4efd732b86af419f5751813ec62961e5384af89728"
  end

  resource "cucumber-gherkin" do
    url "https:rubygems.orggemscucumber-gherkin-26.2.0.gem"
    sha256 "9140cbd4535099eca6d4f62677f08c239198771cecd21a18f57ba87f9365c946"
  end

  resource "cucumber-cucumber-expressions" do
    url "https:rubygems.orggemscucumber-cucumber-expressions-17.0.1.gem"
    sha256 "0b187308d088a773a1f28eaf23914d27281b1cfb877c810c7c69252fe879db77"
  end

  resource "cucumber-tag-expressions" do
    url "https:rubygems.orggemscucumber-tag-expressions-5.0.6.gem"
    sha256 "4e98a9f78691cbd59c6a1aca6033dfb8bba5905719dbeb4d39c2374708e0ab66"
  end

  resource "cucumber-core" do
    url "https:rubygems.orggemscucumber-core-12.0.0.gem"
    sha256 "c2a7f4c457dd64df6cc7f430392fb5c03160805eafb27849639fee65d5bb9dfa"
  end

  resource "cucumber-ci-environment" do
    url "https:rubygems.orggemscucumber-ci-environment-9.2.0.gem"
    sha256 "98121d128af99883f65b3ab78e987be9d57c17e1adeb79783e4bc269b8592128"
  end

  resource "builder" do
    url "https:rubygems.orggemsbuilder-3.2.4.gem"
    sha256 "99caf08af60c8d7f3a6b004029c4c3c0bdaebced6c949165fe98f1db27fbbc10"
  end

  def install
    ENV["GEM_HOME"] = libexec
    resources.each do |r|
      r.fetch
      args = ["--ignore-dependencies", "--no-document", "--install-dir", libexec]
      # Fix segmentation fault on Apple Silicon
      # Ref: https:github.comffiffiissues864#issuecomment-875242776
      args += ["--", "--enable-libffi-alloc"] if r.name == "ffi" && OS.mac? && Hardware::CPU.arm?
      system "gem", "install", r.cached_download, *args
    end
    system "gem", "build", "cucumber.gemspec"
    system "gem", "install", "--ignore-dependencies", "cucumber-#{version}.gem"
    bin.install libexec"bincucumber"
    bin.env_script_all_files(libexec"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    assert_match "create   features", shell_output("#{bin}cucumber --init")
    assert_predicate testpath"features", :exist?
  end
end