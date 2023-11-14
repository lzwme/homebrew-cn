class Haiti < Formula
  desc "Hash type identifier"
  homepage "https://noraj.github.io/haiti/#/"
  url "https://ghproxy.com/https://github.com/noraj/haiti/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "ee1fee20c891db567abe753de25e7f1f1d4c7c59d92b6ce28f2e96606f247828"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "9a79f8a170104a1ac3909ae0425458f8840bc7e3636a5b291959223585235c32"
  end

  # Requires Ruby >= 2.7
  depends_on "ruby"

  # Runtime dependencies of haiti
  # List with `gem install --explain haiti-hash`
  resource "paint" do
    url "https://rubygems.org/gems/paint-2.3.0.gem"
    sha256 "327d623e4038619d5bd99ae5db07973859cd78400c7f0329eea283cef8e83be5"
  end

  resource "docopt" do
    url "https://rubygems.org/gems/docopt-0.6.1.gem"
    sha256 "73f837ed376d015971712c17f7aafa021998b964b77d52997dcaff79d6727467"
  end

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