class Deadfinder < Formula
  desc "Finds broken links"
  homepage "https://rubygems.org/gems/deadfinder"
  url "https://ghfast.top/https://github.com/hahwul/deadfinder/archive/refs/tags/1.9.1.tar.gz"
  sha256 "60942329779ba01d92532bdd3a937bfd04686693b911e6193692daee9634b4e6"
  license "MIT"
  revision 2
  head "https://github.com/hahwul/deadfinder.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "005258486d707c6c6d63a2c03597e64f544f088ede9b9087db046aa4e405aece"
    sha256 cellar: :any,                 arm64_sequoia: "146d09aa4890b2909b1210756224adf5430fe9182d8bdea1f69a9763f570063d"
    sha256 cellar: :any,                 arm64_sonoma:  "8ca275b6c9592cc914faa47b2082a812ff7a6b243928f0e6819c4b37704dee8e"
    sha256 cellar: :any,                 sonoma:        "1a99e5e1a82b6d028fe4ab482a45097868907a034082784a7172d0e9df879965"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f98f587d4c1ddfdb27ac0d2d01553a8b9b5b479b31f015280972985e34d513a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5315fc6ffc693ce9a5213595b8f972a990930905cff4308709b43a56c1b9b563"
  end

  depends_on "pkgconf" => :build
  depends_on "ruby"

  uses_from_macos "libffi"
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "zlib"

  def install
    ENV["BUNDLE_FORCE_RUBY_PLATFORM"] = "1"
    ENV["BUNDLE_VERSION"] = "system" # Avoid installing Bundler into the keg
    ENV["BUNDLE_WITHOUT"] = "development test"
    ENV["GEM_HOME"] = libexec
    ENV["NOKOGIRI_USE_SYSTEM_LIBRARIES"] = "1"

    system "bundle", "install"
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"

    bin.install libexec/"bin/#{name}"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])

    # Remove mkmf.log files to avoid shims references
    rm Dir["#{libexec}/extensions/*/*/*/mkmf.log"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/deadfinder version")

    assert_match "Task completed", shell_output("#{bin}/deadfinder url https://brew.sh")
  end
end