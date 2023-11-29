class Gum < Formula
  desc "Tool for glamorous shell scripts"
  homepage "https://github.com/charmbracelet/gum"
  url "https://ghproxy.com/https://github.com/charmbracelet/gum/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "2af0c3bfb89f5201b48c2009da2c9fffba1819188bf6622e5ef8336e8cc27b10"
  license "MIT"
  head "https://github.com/charmbracelet/gum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9fa0c6a4e645260fc4a8934f8c49c8b3334369028db985fe485c7c05c46ad03c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9fa0c6a4e645260fc4a8934f8c49c8b3334369028db985fe485c7c05c46ad03c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9fa0c6a4e645260fc4a8934f8c49c8b3334369028db985fe485c7c05c46ad03c"
    sha256 cellar: :any_skip_relocation, sonoma:         "b17e5f770f24db492066b05f6a11af6e3f1a65e903d91a7d09fd771b068c5b29"
    sha256 cellar: :any_skip_relocation, ventura:        "b17e5f770f24db492066b05f6a11af6e3f1a65e903d91a7d09fd771b068c5b29"
    sha256 cellar: :any_skip_relocation, monterey:       "b17e5f770f24db492066b05f6a11af6e3f1a65e903d91a7d09fd771b068c5b29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e22060e896f23990bcc45531bdc090ddeec03f6d5e96dd7f388b65e5112cce1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")

    man_page = Utils.safe_popen_read(bin/"gum", "man")
    (man1/"gum.1").write man_page

    generate_completions_from_executable(bin/"gum", "completion")
  end

  test do
    assert_match "Gum", shell_output("#{bin}/gum format 'Gum'").chomp
    assert_equal "foo", shell_output("#{bin}/gum style foo").chomp
    assert_equal "foo\nbar", shell_output("#{bin}/gum join --vertical foo bar").chomp
    assert_equal "foobar", shell_output("#{bin}/gum join foo bar").chomp
  end
end