class Tmuxinator < Formula
  desc "Manage complex tmux sessions easily"
  homepage "https:github.comtmuxinatortmuxinator"
  url "https:github.comtmuxinatortmuxinatorarchiverefstagsv3.3.2.tar.gz"
  sha256 "8b5a8cc899f48772f2a8bace06ff463c57248ad9575a668326f1e60b7e9616f0"
  license "MIT"
  head "https:github.comtmuxinatortmuxinator.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "320992e7a8f5a7c514fa4c3ac9adb271fa5097a75e09996fbd288c444848af8a"
  end

  depends_on "ruby"
  depends_on "tmux"
  depends_on "tmuxinator-completion"

  resource "xdg" do
    url "https:rubygems.orgdownloadsxdg-2.2.5.gem"
    sha256 "f3a5f799363852695e457bb7379ac6c4e3e8cb3a51ce6b449ab47fbb1523b913"
  end

  resource "thor" do
    url "https:rubygems.orgdownloadsthor-1.3.2.gem"
    sha256 "eef0293b9e24158ccad7ab383ae83534b7ad4ed99c09f96f1a6b036550abbeda"
  end

  resource "erubi" do
    url "https:rubygems.orgdownloadserubi-1.12.0.gem"
    sha256 "27bedb74dfb1e04ff60674975e182d8ca787f2224f2e8143268c7696f42e4723"
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

    # Make sure tmuxinator checks HOMEBREW_PREFIX for data files. Also ensures uniform bottles.
    inreplace_files = libexec.glob("gemsxdg-*libxdgbase_dir{,extended}.rb")
    inreplace inreplace_files, "usrlocal", HOMEBREW_PREFIX
  end

  test do
    version_output = shell_output("#{bin}tmuxinator version")
    assert_match "tmuxinator #{version}", version_output

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

    system bin"tmuxinator", "new", "test"
    list_output = shell_output("#{bin}tmuxinator list")
    assert_equal "tmuxinator projects:\ntest\n", list_output
  end
end