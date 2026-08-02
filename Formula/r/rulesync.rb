class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-16.4.0.tgz"
  sha256 "fa227b7605dbab43fff38de691edefd92eb57a39d949108417d7658cc8271525"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c40367f8d0372b314fd8f8757eeed3d488d3979531d503fd57194140cb6c15f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c40367f8d0372b314fd8f8757eeed3d488d3979531d503fd57194140cb6c15f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c40367f8d0372b314fd8f8757eeed3d488d3979531d503fd57194140cb6c15f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c158c3cd195dbf1db1848c718dd46c5872dd7e6aee3483cc361730d1bc05afe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c158c3cd195dbf1db1848c718dd46c5872dd7e6aee3483cc361730d1bc05afe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c158c3cd195dbf1db1848c718dd46c5872dd7e6aee3483cc361730d1bc05afe"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rulesync --version")

    output = shell_output("#{bin}/rulesync init")
    assert_match "rulesync initialized successfully", output
    assert_match "Project overview and general development guidelines", (testpath/".rulesync/rules/overview.md").read
  end
end