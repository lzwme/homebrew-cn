class Deadfinder < Formula
  desc "Finds broken links"
  homepage "https:rubygems.orggemsdeadfinder"
  url "https:github.comhahwuldeadfinderarchiverefstags1.4.0.tar.gz"
  sha256 "15934889544d008cf9b87ce69123f7bed4ba6587bbc3aef82a60d625d2675cec"
  license "MIT"
  head "https:github.comhahwuldeadfinder.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9b3153adcb17a495aefc313497dce90327eb01ee24f3afd89f859629616687a2"
    sha256 cellar: :any,                 arm64_sonoma:  "476d1c7d6def072e651ddf73c9bbe0139ade11ef300846ef6f8ed87a72898e2c"
    sha256 cellar: :any,                 arm64_ventura: "6899d7a9d3c168cb83de25506b1af305dd2f23340c4ae6dea9a1d50785f9f5c5"
    sha256 cellar: :any,                 sonoma:        "be54c4a324468ba4d68c45f56e0dff40a53e24c914391debdba67f084133c76f"
    sha256 cellar: :any,                 ventura:       "af484959880cc03137dac095a779b78592cd04db688f99610c056b02d707a053"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b94ada59473a9b74b0d9e299045628dca2d8a808400f8f97c415fbb61de2ffa0"
  end

  depends_on "ruby"

  uses_from_macos "libffi"
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "xz"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
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
  end

  test do
    assert_match version.to_s, shell_output(bin"deadfinder version")

    assert_match "Done", shell_output(bin"deadfinder url https:brew.sh")
  end
end