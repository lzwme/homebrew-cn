class Gum < Formula
  desc "Tool for glamorous shell scripts"
  homepage "https:github.comcharmbraceletgum"
  url "https:github.comcharmbraceletgumarchiverefstagsv0.14.4.tar.gz"
  sha256 "0570d76f513f749e64e02d56eaff4f5e9987dcf5aeeba7ed36a09af7517fb2ac"
  license "MIT"
  head "https:github.comcharmbraceletgum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "582c9cd177eb047b75da262f3d201c6e9e554d7c996607eeb23ce221170c55f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "582c9cd177eb047b75da262f3d201c6e9e554d7c996607eeb23ce221170c55f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "582c9cd177eb047b75da262f3d201c6e9e554d7c996607eeb23ce221170c55f8"
    sha256 cellar: :any_skip_relocation, sonoma:         "734cbfcad8f74ec515f4116dde738a44704f69aec673905a05fcd3df5a07ea00"
    sha256 cellar: :any_skip_relocation, ventura:        "734cbfcad8f74ec515f4116dde738a44704f69aec673905a05fcd3df5a07ea00"
    sha256 cellar: :any_skip_relocation, monterey:       "734cbfcad8f74ec515f4116dde738a44704f69aec673905a05fcd3df5a07ea00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2890323046503cfc2940e0e82e1a951dba921af47a4a4c92f1172758460091bf"
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