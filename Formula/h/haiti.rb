class Haiti < Formula
  desc "Hash type identifier"
  homepage "https://noraj.github.io/haiti/#/"
  url "https://ghproxy.com/https://github.com/noraj/haiti/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "3aaf22e5d918c3d1498a96129f12fa559ccbe8a29cd89ee4a59c12132de35871"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "124b868e17cfe4c528f1b0ebbcb26c520fc1586b6aa3bb9c4ad1bf0e4a1dfe1e"
  end

  # Requires Ruby >= 2.7
  depends_on "ruby"

  # upstream patch for haiti-hash gem version
  resource "paint" do
    url "https://rubygems.org/gems/paint-2.3.0.gem"
    sha256 "327d623e4038619d5bd99ae5db07973859cd78400c7f0329eea283cef8e83be5"
  end

  resource "docopt" do
    url "https://rubygems.org/gems/docopt-0.6.1.gem"
    sha256 "73f837ed376d015971712c17f7aafa021998b964b77d52997dcaff79d6727467"
  end

  patch do
    url "https://github.com/noraj/haiti/commit/45d70981997038b950b832aa1b18e624ca66725d.patch?full_index=1"
    sha256 "be06dc98947770020c36a9a6d6c62046657fe756234f134af0b6abc3ca232ecb"
  end

  # Runtime dependencies of haiti
  # List with `gem install --explain haiti-hash`

  def install
    ENV["GEM_HOME"] = libexec
    resources.each do |r|
      system "gem", "install", r.cached_download, "--ignore-dependencies",
             "--no-document", "--install-dir", libexec
    end
    system "gem", "build", "haiti.gemspec"
    system "gem", "install", "haiti-hash-#{version}.gem"
    bin.install Dir[libexec/"bin/haiti"]
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/haiti --version")

    output = shell_output("#{bin}/haiti 12c87370d1b5472793e67682596b60efe2c6038d63d04134a1a88544509737b4")
    assert_match "[JtR: raw-sha256]", output
  end
end