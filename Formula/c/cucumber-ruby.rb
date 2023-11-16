class CucumberRuby < Formula
  desc "Cucumber for Ruby"
  homepage "https://cucumber.io"
  url "https://ghproxy.com/https://github.com/cucumber/cucumber-ruby/archive/refs/tags/v9.1.0.tar.gz"
  sha256 "49397539d952ff95399ba133cc5b8c0c8e85c2177de0cf08b363a21bd5ac2cd7"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "221fdc929a6cb031f589a090cd57fe4b8fd83d1c23e942a758a8fa9a97b83e35"
    sha256 cellar: :any,                 arm64_ventura:  "351d11164a018bdd3d61b68fe21d4de9edcafd25a766e00228866a6db757fbfd"
    sha256 cellar: :any,                 arm64_monterey: "54429e08adab1d520609951256da1c0e9f40e445fa05e83582b9b7abff0aba19"
    sha256 cellar: :any,                 sonoma:         "6133cf5d9a36dcfd385254ddf840c74ff2e87ecc4215f75df7b44cab7547c72f"
    sha256 cellar: :any,                 ventura:        "3bfd875969c9b69e745a4310d47ecef9dbea1a149f7281fc4a8700941f5106be"
    sha256 cellar: :any,                 monterey:       "230bc84e7bb1a2460197c8766d9082490ffcd046e5b537ac27c2fb694a1d02fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f450ad7d4f0a9c8afdb6a12f422b901916ed6caa64c8f593cc1dac4de81bcfcf"
  end

  depends_on "pkg-config" => :build
  depends_on "ruby" # Requires >= Ruby 2.7

  uses_from_macos "libffi", since: :catalina

  # Runtime dependencies of cucumber
  # List with `gem install --explain cucumber`
  # https://rubygems.org/gems/cucumber/versions/9.0.1/dependencies

  resource "ffi" do
    url "https://rubygems.org/gems/ffi-1.15.5.gem"
    sha256 "6f2ed2fa68047962d6072b964420cba91d82ce6fa8ee251950c17fca6af3c2a0"
  end

  resource "sys-uname" do
    url "https://rubygems.org/gems/sys-uname-1.2.3.gem"
    sha256 "63c51d55180828c8e58847eb5c24934eed057f87fb016de6062aa11bf1c5490e"
  end

  resource "multi_test" do
    url "https://rubygems.org/gems/multi_test-1.1.0.gem"
    sha256 "e9e550cdd863fb72becfe344aefdcd4cbd26ebf307847f4a6c039a4082324d10"
  end

  resource "mini_mime" do
    url "https://rubygems.org/gems/mini_mime-1.1.5.gem"
    sha256 "8681b7e2e4215f2a159f9400b5816d85e9d8c6c6b491e96a12797e798f8bccef"
  end

  resource "diff-lcs" do
    url "https://rubygems.org/gems/diff-lcs-1.5.0.gem"
    sha256 "49b934001c8c6aedb37ba19daec5c634da27b318a7a3c654ae979d6ba1929b67"
  end

  resource "cucumber-messages" do
    url "https://rubygems.org/gems/cucumber-messages-22.0.0.gem"
    sha256 "d08a6c228675dd036896bebe82a29750cbdc4dacd461e39edd1199dfa36da719"
  end

  resource "cucumber-html-formatter" do
    url "https://rubygems.org/gems/cucumber-html-formatter-20.4.0.gem"
    sha256 "badccd4188f9c3b105c8a99b800a065b7d2d2feb406fcfa13b0dc7f59d6285aa"
  end

  resource "cucumber-gherkin" do
    url "https://rubygems.org/gems/cucumber-gherkin-26.2.0.gem"
    sha256 "9140cbd4535099eca6d4f62677f08c239198771cecd21a18f57ba87f9365c946"
  end

  resource "cucumber-cucumber-expressions" do
    url "https://rubygems.org/gems/cucumber-cucumber-expressions-17.0.0.gem"
    sha256 "56f8b1eb9a9869f843da6ac97643cd4c08bbcefb408919162dbe1d9d043497e0"
  end

  resource "cucumber-tag-expressions" do
    url "https://rubygems.org/gems/cucumber-tag-expressions-5.0.6.gem"
    sha256 "4e98a9f78691cbd59c6a1aca6033dfb8bba5905719dbeb4d39c2374708e0ab66"
  end

  resource "cucumber-core" do
    url "https://rubygems.org/gems/cucumber-core-12.0.0.gem"
    sha256 "c2a7f4c457dd64df6cc7f430392fb5c03160805eafb27849639fee65d5bb9dfa"
  end

  resource "cucumber-ci-environment" do
    url "https://rubygems.org/gems/cucumber-ci-environment-9.2.0.gem"
    sha256 "98121d128af99883f65b3ab78e987be9d57c17e1adeb79783e4bc269b8592128"
  end

  resource "builder" do
    url "https://rubygems.org/gems/builder-3.2.4.gem"
    sha256 "99caf08af60c8d7f3a6b004029c4c3c0bdaebced6c949165fe98f1db27fbbc10"
  end

  def install
    ENV["GEM_HOME"] = libexec
    resources.each do |r|
      r.fetch
      args = ["--ignore-dependencies", "--no-document", "--install-dir", libexec]
      # Fix segmentation fault on Apple Silicon
      # Ref: https://github.com/ffi/ffi/issues/864#issuecomment-875242776
      args += ["--", "--enable-libffi-alloc"] if r.name == "ffi" && OS.mac? && Hardware::CPU.arm?
      system "gem", "install", r.cached_download, *args
    end
    system "gem", "build", "cucumber.gemspec"
    system "gem", "install", "--ignore-dependencies", "cucumber-#{version}.gem"
    bin.install libexec/"bin/cucumber"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    assert_match "create   features", shell_output("#{bin}/cucumber --init")
    assert_predicate testpath/"features", :exist?
  end
end