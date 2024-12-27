class CucumberRuby < Formula
  desc "Cucumber for Ruby"
  homepage "https:cucumber.io"
  url "https:github.comcucumbercucumber-rubyarchiverefstagsv9.2.0.tar.gz"
  sha256 "fd8eae54016de9055e84fd4251d873bc9a64d0929b02b4355762ce82ab2874b7"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5c88e29863e16ab85da2bdd2643008f6cfda6dfa5eb405d9646c25efa247c4e0"
    sha256 cellar: :any,                 arm64_sonoma:  "345fa4270fa2b3f6299b8cc7c72de8ca93062885d90aca984181cf0f660c63d8"
    sha256 cellar: :any,                 arm64_ventura: "368f53c28309264a68bdf2d1083a9d8960ed160b1da00738f5d4d926d73c7a5e"
    sha256 cellar: :any,                 sonoma:        "981eb23c1e51bf9561c3342ea5b344b655802fa590eca52b9063bf8ef77196f6"
    sha256 cellar: :any,                 ventura:       "d9f836caa2bee5a0e5373652bbe28973bb4a362257bbd87681d4865c35735377"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "332cf9475689eb12111a387cad66d54655d109115809b42c8c7e014d1ccb349a"
  end

  depends_on "pkgconf" => :build
  depends_on "ruby@3.3" # ruby 3.4 support bug report, https:github.comcucumbercucumber-rubyissues1769

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
    url "https:rubygems.orggemsdiff-lcs-1.5.1.gem"
    sha256 "273223dfb40685548436d32b4733aa67351769c7dea621da7d9dd4813e63ddfe"
  end

  resource "cucumber-messages" do
    url "https:rubygems.orggemscucumber-messages-22.0.0.gem"
    sha256 "d08a6c228675dd036896bebe82a29750cbdc4dacd461e39edd1199dfa36da719"
  end

  resource "cucumber-html-formatter" do
    url "https:rubygems.orggemscucumber-html-formatter-21.3.0.gem"
    sha256 "8177d4e989b6035a4108064e60d806768cbe9040c9740f9cfb872cb40685f673"
  end

  resource "cucumber-gherkin" do
    url "https:rubygems.orggemscucumber-gherkin-27.0.0.gem"
    sha256 "2e6a8212c1d0107f95d75082e8bd5f05ace4e42dd77a396c7b713be3a8067718"
  end

  resource "bigdecimal" do
    url "https:rubygems.orggemsbigdecimal-3.1.5.gem"
    sha256 "534faee5ae3b4a0a6369fe56cd944e907bf862a9209544a9e55f550592c22fac"
  end

  resource "cucumber-cucumber-expressions" do
    url "https:rubygems.orggemscucumber-cucumber-expressions-17.0.2.gem"
    sha256 "b1df950bca16843e2948c709592f3b0cf6a20ba4804299e35c30688e15ff4c73"
  end

  resource "cucumber-tag-expressions" do
    url "https:rubygems.orggemscucumber-tag-expressions-6.1.0.gem"
    sha256 "612e521a1ee48495b549f15ae51ecfbfc901ee786245356d38f81c13b6a10ebc"
  end

  resource "cucumber-core" do
    url "https:rubygems.orggemscucumber-core-13.0.1.gem"
    sha256 "757f9dbfb1e2e0eec19f5fc1091b56a388fb42ba23322be8f10207e6fab3c5c9"
  end

  resource "cucumber-ci-environment" do
    url "https:rubygems.orggemscucumber-ci-environment-10.0.1.gem"
    sha256 "bb6e3fcec85c981dff4561997e8675a7123eead5fe9e587d2ad7568adbe18631"
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