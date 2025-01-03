class Goread < Formula
  desc "RSSAtom feeds in the terminal"
  homepage "https:github.comTypicalAMgoread"
  url "https:github.comTypicalAMgoreadarchiverefstagsv1.7.2.tar.gz"
  sha256 "103e5bcb444f92344f883b23a429424a1bfc1dec418af1db7476fc8e90552f03"
  license "GPL-3.0-or-later"
  head "https:github.comTypicalAMgoread.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d646681aeffc7e1f5cad4106b8f6ce28e23263b346d2129baecb868ab153638"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d646681aeffc7e1f5cad4106b8f6ce28e23263b346d2129baecb868ab153638"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2d646681aeffc7e1f5cad4106b8f6ce28e23263b346d2129baecb868ab153638"
    sha256 cellar: :any_skip_relocation, sonoma:        "cbed2eaba2ccd581ddc42196663bf48d527c2b17411ad0ef6eb2157fcd706924"
    sha256 cellar: :any_skip_relocation, ventura:       "cbed2eaba2ccd581ddc42196663bf48d527c2b17411ad0ef6eb2157fcd706924"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a7c3cbdee9df5a21a522f6e55a25a8c70b9f3bb054f4cbf4e561d6ef321c1d4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}goread --test_colors")
    assert_match "A table of all the colors", output

    assert_match version.to_s, shell_output("#{bin}goread --version")
  end
end