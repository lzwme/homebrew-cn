class Sugarjar < Formula
  desc "Helper utility for a better GitGitHub experience"
  homepage "https:github.comjaymzhsugarjar"
  url "https:github.comjaymzhsugarjararchiverefstagsv1.1.2.tar.gz"
  sha256 "5639b253c0e9d2c61e22d7b687c616750ab9359457241ec10844865228b3ce8d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "0d00a073b001f340a4b71902f2ac6c8816750e65ac63ddd39d10f4991dd3d8ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "890a1d99d837faddc6905a810ced07d286467aa852fe832a9d7f201b6edff5d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "890a1d99d837faddc6905a810ced07d286467aa852fe832a9d7f201b6edff5d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "890a1d99d837faddc6905a810ced07d286467aa852fe832a9d7f201b6edff5d9"
    sha256 cellar: :any_skip_relocation, sonoma:         "46b28ef5fbb8d993ff0cdced2798d28afc18a203294fc38fea992472e022e3d1"
    sha256 cellar: :any_skip_relocation, ventura:        "46b28ef5fbb8d993ff0cdced2798d28afc18a203294fc38fea992472e022e3d1"
    sha256 cellar: :any_skip_relocation, monterey:       "46b28ef5fbb8d993ff0cdced2798d28afc18a203294fc38fea992472e022e3d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "890a1d99d837faddc6905a810ced07d286467aa852fe832a9d7f201b6edff5d9"
  end

  depends_on "gh"
  # Requires Ruby >= 3.0
  depends_on "ruby"

  def install
    ENV["GEM_HOME"] = libexec
    system "bundle", "config", "set", "without", "development", "test"
    system "bundle", "install"
    system "gem", "build", "sugarjar.gemspec"
    system "gem", "install", "--ignore-dependencies", "sugarjar-#{version}.gem"
    bin.install libexec"binsj"
    bin.env_script_all_files(libexec"bin", GEM_HOME: ENV["GEM_HOME"])
    bash_completion.install "extrassugarjar_completion.bash"
  end

  test do
    output = shell_output("#{bin}sj lint", 1)
    assert_match "sugarjar must be run from inside a git repo", output
    output = shell_output("#{bin}sj bclean", 1)
    assert_match "sugarjar must be run from inside a git repo", output
  end
end