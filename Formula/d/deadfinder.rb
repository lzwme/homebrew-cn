class Deadfinder < Formula
  desc "Finds broken links"
  homepage "https:rubygems.orggemsdeadfinder"
  url "https:github.comhahwuldeadfinderarchiverefstags1.7.0.tar.gz"
  sha256 "f3fdb26e3a6c3f8f3b0f41d79c61f282e57b680c732636545662baede420dfa7"
  license "MIT"
  head "https:github.comhahwuldeadfinder.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3802f961fbb591240f1c49edb47c6eb7e64371681571fe83628f481a1a026270"
    sha256 cellar: :any,                 arm64_sonoma:  "3974c5c083fc9a56f25802b003367ee4b63c95aa26431c1eb72d87083eb135c5"
    sha256 cellar: :any,                 arm64_ventura: "fdd069f39c89ddedb5f4171852c3572e7afcd2df697d53406b79e915a47979a0"
    sha256 cellar: :any,                 sonoma:        "2fa21d9440b959062d56c84129c2c79a1ae4480707c65ba021ec1574d7423547"
    sha256 cellar: :any,                 ventura:       "f4b93d6e0266b8336349e9d98eb35fe6e57d9c9f83e542922fad7cc2d2b638ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aba0f1aac6e739f6be018d214783b6fa28c3f905f8330693a58d131142787d87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92657c8342bb2a52ee4a33e5d56a884d07fc4e9e8cfd7d34418f6110db977578"
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

    assert_match "Task completed", shell_output(bin"deadfinder url https:brew.sh")
  end
end