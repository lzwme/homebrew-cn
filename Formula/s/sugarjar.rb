class Sugarjar < Formula
  desc "Helper utility for a better GitGitHub experience"
  homepage "https:github.comjaymzhsugarjar"
  url "https:github.comjaymzhsugarjararchiverefstagsv1.1.0.tar.gz"
  sha256 "5a75fab10cfb1509ae9e7ee5cfced13afbfec19e44e5020acf4a219f9c04f79c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4c7417515051fd9decc51f77a4d4f19749dc1c61a5802696140d93f28cef2864"
    sha256 cellar: :any,                 arm64_ventura:  "62ee728a81c18f1b926824dfb52a0845ee66a99034a004ab26f6f6cb52132b34"
    sha256 cellar: :any,                 arm64_monterey: "4b95b2fa461e1386af8b9ba962c579fb4e926e3a9ad917b4d4a1651a7b4a4e0b"
    sha256 cellar: :any,                 sonoma:         "67864cca5dd7d12755920b3a6b5ea5aa0f4315fc1473457a2b4ec31cd5a303f4"
    sha256 cellar: :any,                 ventura:        "3a6eacee3045fa7171f2d1d0fdd016bf7c3aeb79ea7ad0522788f2fbb9f745db"
    sha256 cellar: :any,                 monterey:       "b6fd9bc72594e4f37ff186d96ddc87be457d6428ec140fce79951c2a9a923df0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33268b02c480c99c1206a84d2fbbffb469ae3a43167bac16a1d82e9eebdb25da"
  end

  depends_on "gh"
  # Requires Ruby >= 3.0
  depends_on "ruby"

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "install", "bundler"
    system "bundle", "install"
    system "gem", "build", "sugarjar.gemspec"
    system "gem", "install", "--ignore-dependencies", "sugarjar-#{version}.gem"
    bin.install libexec"binsj"
    bin.env_script_all_files(libexec"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    output = shell_output("#{bin}sj lint", 1)
    assert_match "sugarjar must be run from inside a git repo", output
    output = shell_output("#{bin}sj bclean", 1)
    assert_match "sugarjar must be run from inside a git repo", output
  end
end