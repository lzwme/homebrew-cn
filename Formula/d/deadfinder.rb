class Deadfinder < Formula
  desc "Finds broken links"
  homepage "https:rubygems.orggemsdeadfinder"
  url "https:github.comhahwuldeadfinderarchiverefstags1.6.1.tar.gz"
  sha256 "89eb3ce461b89b486220fa61579cda71c2ea90a261588a98f58cc66202883b82"
  license "MIT"
  head "https:github.comhahwuldeadfinder.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "efc9928572c884c80a7e59c3c675ea46d781a106f4e1a236acec6ed7f0976905"
    sha256 cellar: :any,                 arm64_sonoma:  "b731c16bf1072df8a1011135c1a14183307c2c0f9bf10c6d4e6c7dd2aa8cfb01"
    sha256 cellar: :any,                 arm64_ventura: "f765a8266eed82684d1a041f3d3e113cba5f24e406f108b08b7225cbf72beef3"
    sha256 cellar: :any,                 sonoma:        "1a73db10abec6cb50b32b4994be240a9ca70cfa7cac16a8e217455b00600bf7d"
    sha256 cellar: :any,                 ventura:       "f89f8c61528f8e464eb8c37a4cf0d78e3885c3a4e2fada667bee2861a0c849a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5fb674b529b8a3549a7af2244045f8d3a4982c45351829f1856998e0bccd649"
  end

  depends_on "ruby"

  uses_from_macos "libffi"
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "xz"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkgconf" => :build
  end

  def install
    ENV["GEM_HOME"] = libexec
    ENV["NOKOGIRI_USE_SYSTEM_LIBRARIES"] = "1"

    system "bundle", "config", "set", "without", "development", "test"
    system "bundle", "install"
    system "gem", "build", "deadfinder.gemspec"
    system "gem", "install", "deadfinder-#{version}.gem"

    bin.install libexec"bindeadfinder"
    bin.env_script_all_files(libexec"bin", GEM_HOME: ENV["GEM_HOME"])

    # Remove mkmf.log files to avoid shims references
    rm Dir["#{libexec}extensions***mkmf.log"]
  end

  test do
    assert_match version.to_s, shell_output(bin"deadfinder version")

    assert_match "Done", shell_output(bin"deadfinder url https:brew.sh")
  end
end