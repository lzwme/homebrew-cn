class Gum < Formula
  desc "Tool for glamorous shell scripts"
  homepage "https:github.comcharmbraceletgum"
  url "https:github.comcharmbraceletgumarchiverefstagsv0.15.1.tar.gz"
  sha256 "bd3c3ad77ea7699e82b3688797b72c38116dd781ef93bd35bdc11bd80d1aec1c"
  license "MIT"
  head "https:github.comcharmbraceletgum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa1f5d675f03ea5234146ba051b31e39941705c6306acd8b3b8fa7e013eb5476"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa1f5d675f03ea5234146ba051b31e39941705c6306acd8b3b8fa7e013eb5476"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aa1f5d675f03ea5234146ba051b31e39941705c6306acd8b3b8fa7e013eb5476"
    sha256 cellar: :any_skip_relocation, sonoma:        "5944591726e1c5ab573aef40572877579ccb6a423d3b1167194c9fa30f853064"
    sha256 cellar: :any_skip_relocation, ventura:       "5944591726e1c5ab573aef40572877579ccb6a423d3b1167194c9fa30f853064"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2af1757d4bee2c4253592c8446a3f25631fa723fc180fb3f82c34c7145c72512"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")

    man_page = Utils.safe_popen_read(bin"gum", "man")
    (man1"gum.1").write man_page

    generate_completions_from_executable(bin"gum", "completion")
  end

  test do
    assert_match "Gum", shell_output("#{bin}gum format 'Gum'").chomp
    assert_equal "foo", shell_output("#{bin}gum style foo").chomp
    assert_equal "foo\nbar", shell_output("#{bin}gum join --vertical foo bar").chomp
    assert_equal "foobar", shell_output("#{bin}gum join foo bar").chomp
  end
end