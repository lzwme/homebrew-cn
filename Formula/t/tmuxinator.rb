class Tmuxinator < Formula
  desc "Manage complex tmux sessions easily"
  homepage "https:github.comtmuxinatortmuxinator"
  url "https:github.comtmuxinatortmuxinatorarchiverefstagsv3.1.0.tar.gz"
  sha256 "5d5a2d0bcfc507f5a4518fe5f8077cb449040a504d0701cdde59b63f927adbfe"
  license "MIT"
  head "https:github.comtmuxinatortmuxinator.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a61fb0b1b6eff41f01ffba826b193b841fe9adf773b4d4c86edb3e6d7434f5ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a61fb0b1b6eff41f01ffba826b193b841fe9adf773b4d4c86edb3e6d7434f5ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a61fb0b1b6eff41f01ffba826b193b841fe9adf773b4d4c86edb3e6d7434f5ff"
    sha256 cellar: :any_skip_relocation, sonoma:         "71626e5b4921ff7f4f1bace4a9c3ca91b68ac1bf1433e585827d524e912ab097"
    sha256 cellar: :any_skip_relocation, ventura:        "71626e5b4921ff7f4f1bace4a9c3ca91b68ac1bf1433e585827d524e912ab097"
    sha256 cellar: :any_skip_relocation, monterey:       "71626e5b4921ff7f4f1bace4a9c3ca91b68ac1bf1433e585827d524e912ab097"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a61fb0b1b6eff41f01ffba826b193b841fe9adf773b4d4c86edb3e6d7434f5ff"
  end

  depends_on "ruby"
  depends_on "tmux"

  conflicts_with "tmuxinator-completion", because: "the tmuxinator formula includes completion"

  resource "erubis" do
    url "https:rubygems.orgdownloadserubis-2.7.0.gem"
    sha256 "63653f5174a7997f6f1d6f465fbe1494dcc4bdab1fb8e635f6216989fb1148ba"
  end

  resource "thor" do
    url "https:rubygems.orgdownloadsthor-1.3.0.gem"
    sha256 "1adc7f9e5b3655a68c71393fee8bd0ad088d14ee8e83a0b73726f23cbb3ca7c3"
  end

  resource "xdg" do
    url "https:rubygems.orgdownloadsxdg-2.2.5.gem"
    sha256 "f3a5f799363852695e457bb7379ac6c4e3e8cb3a51ce6b449ab47fbb1523b913"
  end

  def install
    ENV["GEM_HOME"] = libexec
    resources.each do |r|
      r.fetch
      system "gem", "install", r.cached_download, "--ignore-dependencies",
             "--no-document", "--install-dir", libexec
    end

    system "gem", "build", "tmuxinator.gemspec"
    system "gem", "install", "--ignore-dependencies", "tmuxinator-#{version}.gem"
    bin.install libexec"bintmuxinator"
    bin.env_script_all_files(libexec"bin", GEM_HOME: ENV["GEM_HOME"])

    bash_completion.install "completiontmuxinator.bash" => "tmuxinator"
    zsh_completion.install "completiontmuxinator.zsh" => "_tmuxinator"
    fish_completion.install Dir["completion*.fish"]
  end

  test do
    version_output = shell_output("#{bin}tmuxinator version")
    assert_match "tmuxinator #{version}", version_output

    completion = shell_output("bash -c 'source #{bash_completion}tmuxinator && complete -p tmuxinator'")
    assert_match "-F _tmuxinator", completion

    commands = shell_output("#{bin}tmuxinator commands")
    commands_list = %w[
      commands completions new edit open start
      stop local debug copy delete implode
      version doctor list
    ]

    expected_commands = commands_list.join("\n")
    assert_match expected_commands, commands

    list_output = shell_output("#{bin}tmuxinator list")
    assert_match "tmuxinator projects:", list_output

    system "#{bin}tmuxinator", "new", "test"
    list_output = shell_output("#{bin}tmuxinator list")
    assert_equal "tmuxinator projects:\ntest\n", list_output
  end
end