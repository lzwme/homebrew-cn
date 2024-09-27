class Deadfinder < Formula
  desc "Finds broken links"
  homepage "https:rubygems.orggemsdeadfinder"
  url "https:github.comhahwuldeadfinderarchiverefstags1.3.6.tar.gz"
  sha256 "c632186a0295165f2a78bd0c337398cb8a6b38b4769f53e729d023fe0782fd24"
  license "MIT"
  head "https:github.comhahwuldeadfinder.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1b12c98f98e43bc5670d5cbe8c6e9188af83a1777b095a0adb00734762e983ed"
    sha256 cellar: :any,                 arm64_sonoma:  "a3dfd68e54e394277e9ac963be5a313137cf470a5711fcd935d3c4f1aaffa1d3"
    sha256 cellar: :any,                 arm64_ventura: "e740e77e993a4b7b93b99d901926b84ee02880e186567f300cd853067756b52b"
    sha256 cellar: :any,                 sonoma:        "a5307ca046e3aa322e03980a355320734a9b5ccd39d91e32cdf84549474b52ea"
    sha256 cellar: :any,                 ventura:       "1990dec47895f02e98c70a1f6ffc1dec971609db04fdec9328848d1133f5493a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb0f6eef47357ba07619bbe153467deb920d3b3e4847c9eef242f56f7baaecfc"
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