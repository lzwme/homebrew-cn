class Ghi < Formula
  desc "Work on GitHub issues on the command-line"
  homepage "https:github.comdrazisilghi"
  url "https:github.comdrazisilghiarchiverefstags1.2.1.tar.gz"
  sha256 "83fbc4918ddf14df77ef06b28922f481747c6f4dc99b865e15d236b1db98c0b8"
  license "MIT"
  head "https:github.comdrazisilghi.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "0574be1c2bb4fe60f4c7e9add399b4c90cb65ea4f822aeddd6233213f83ee10a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8d1a0a48ba1c295cef475eb7ebfdb13ab669619f53374a80abcf405bca5db766"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "43ccd9845bf6f7e2a99d4ced9f23ee0f9e859d15af547ce115d61c149ef12f4c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43ccd9845bf6f7e2a99d4ced9f23ee0f9e859d15af547ce115d61c149ef12f4c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c96d29c0f571a6444c7472f9b607ceb76d21ca1d05eb5152d97d4d4b7549a8f3"
    sha256 cellar: :any_skip_relocation, sonoma:         "8d1a0a48ba1c295cef475eb7ebfdb13ab669619f53374a80abcf405bca5db766"
    sha256 cellar: :any_skip_relocation, ventura:        "43ccd9845bf6f7e2a99d4ced9f23ee0f9e859d15af547ce115d61c149ef12f4c"
    sha256 cellar: :any_skip_relocation, monterey:       "43ccd9845bf6f7e2a99d4ced9f23ee0f9e859d15af547ce115d61c149ef12f4c"
    sha256 cellar: :any_skip_relocation, big_sur:        "c96d29c0f571a6444c7472f9b607ceb76d21ca1d05eb5152d97d4d4b7549a8f3"
    sha256 cellar: :any_skip_relocation, catalina:       "c96d29c0f571a6444c7472f9b607ceb76d21ca1d05eb5152d97d4d4b7549a8f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "c85b10edecd94e2d70e0ffe950da8045a17ef9cbf5ede17bc9d1862a48e6ce75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ed8ec4aa3e0a7ce79f81e4581d07700c1cc1cc2b6bfbfd59086de317f020340"
  end

  uses_from_macos "ruby"

  resource "pygments.rb" do
    url "https:rubygems.orggemspygments.rb-2.3.0.gem"
    sha256 "4c41c8baee10680d808b2fda9b236fe6b2799cd4ce5c15e29b936cf4bf97f510"
  end

  def install
    ENV["GEM_HOME"] = libexec
    resources.each do |r|
      r.fetch
      system "gem", "install", r.cached_download, "--no-document",
                    "--install-dir", libexec
    end
    bin.install "ghi"
    bin.env_script_all_files(libexec"bin", GEM_HOME: ENV["GEM_HOME"])
    man1.install "manghi.1"
  end

  test do
    system bin"ghi", "--version"
  end
end