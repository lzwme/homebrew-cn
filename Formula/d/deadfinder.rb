class Deadfinder < Formula
  desc "Finds broken links"
  homepage "https:rubygems.orggemsdeadfinder"
  url "https:github.comhahwuldeadfinderarchiverefstags1.5.0.tar.gz"
  sha256 "5575127e8ca9c8531991ad32d04bda3f55f13cc657cf01ac0c6ace9d01c59a8a"
  license "MIT"
  revision 1
  head "https:github.comhahwuldeadfinder.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ca7c791406c6678f095db0de61eeaf57f0b3b84c2e7bb528e7689068f6872b15"
    sha256 cellar: :any,                 arm64_sonoma:  "d108973ecb0e997d9fad8195a1f94cd6d40c8990ef194752ab62d9bada7a2394"
    sha256 cellar: :any,                 arm64_ventura: "9664882a92b5ab17000ab3f37fca0b6ddb7504b85af5a16b6503b2d5212e7529"
    sha256 cellar: :any,                 sonoma:        "108aeceb9b251d7db74079bd22f5a2504f6d695a410e9cca3d3930417f3e4879"
    sha256 cellar: :any,                 ventura:       "ea58666962947c02961aa21dc30c9edb87532b3dea2077a4c7c4eaad785ddb00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45af1d2eb23bd4388788f928fa7ed7df07a3fce958bc17eda6cbf73391d55145"
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