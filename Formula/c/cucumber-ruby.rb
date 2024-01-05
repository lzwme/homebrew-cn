class CucumberRuby < Formula
  desc "Cucumber for Ruby"
  homepage "https:cucumber.io"
  url "https:github.comcucumbercucumber-rubyarchiverefstagsv9.1.1.tar.gz"
  sha256 "0ed71e206463b0deef9b50bfcbf611ec3efd2075aca93505559ed16670b39b79"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "abb7b4282873196bed3e4c7309aa4be6664bae5803208a4034e972f0c01c1705"
    sha256 cellar: :any,                 arm64_ventura:  "c85a8f1534ffef700b1022a6069a2c8b554cddfdd4203acb10acb70646edef99"
    sha256 cellar: :any,                 arm64_monterey: "42c8f17928c6d220ed0d1b05c2f16150ab9ac38f3b0aff8b3c4f4f8bd57421b5"
    sha256 cellar: :any,                 sonoma:         "1f235847b45c3a8ede02261b76b8e5b7f3d2651f89dc8fdcb9a1b4e8060cf89e"
    sha256 cellar: :any,                 ventura:        "581c6aec1cde3857970775ce20bb5c4a1a064ab39351edb3f39063c9b1a6a23d"
    sha256 cellar: :any,                 monterey:       "42123d3ea576353fb483b8668acf56c335ac3e6ceb0d5132be6def0babd20e9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4dc0953b45fa658c5edc1ad94b0ca4d2eb9d6d267f5e7257a2d7a5e5cd10f457"
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