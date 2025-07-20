class MCli < Formula
  desc "Swiss Army Knife for macOS"
  homepage "https://github.com/rgcr/m-cli"
  url "https://ghfast.top/https://github.com/rgcr/m-cli/archive/refs/tags/v2.0.4.tar.gz"
  sha256 "03da227d3627811dcc037c184cf338af2fa4b60461ee7bf10ab94effd38132a0"
  license "MIT"
  head "https://github.com/rgcr/m-cli.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fac533647392c33b2902a35a414c84325d38ab2f8acaf67dc14160de44437d44"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fac533647392c33b2902a35a414c84325d38ab2f8acaf67dc14160de44437d44"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fac533647392c33b2902a35a414c84325d38ab2f8acaf67dc14160de44437d44"
    sha256 cellar: :any_skip_relocation, sonoma:        "a559e8a19d9bfb765820e8a009bb8ff8ba3dd3a3815c92dc5e6df352ff2eb0bb"
    sha256 cellar: :any_skip_relocation, ventura:       "a559e8a19d9bfb765820e8a009bb8ff8ba3dd3a3815c92dc5e6df352ff2eb0bb"
  end

  depends_on :macos

  def install
    prefix.install Dir["*"]

    inreplace prefix/"m" do |s|
      # Use absolute rather than relative path to plugins.
      s.sub!(/^MCLI_PATH=.+$/, "MCLI_PATH=#{prefix}")
      # Disable options "update" && "uninstall", they must be handled by brew
      s.sub!(/^\s*update_mcli\s*&&.*/,
             'printf "\'m-cli\' was installed by brew, try: brew update && brew upgrade m-cli\n" && exit 0')
      s.sub!(/^\s*uninstall_mcli\s*&&.*/,
             'printf "\'m-cli\' was installed by brew, try: brew uninstall m-cli\n" && exit 0')
      s.sub!(/^\s*get_version\s*&&.*/,
             "printf \"m-cli version: v2.0.4\\n\" && exit 0")
    end

    inreplace prefix/"completions/bash/m" do |s|
      # Use absolute brew path for bash completion
      s.sub!(/^\s*local PLUGINS_DIR=.+$/, "local PLUGINS_DIR=#{prefix}/plugins")
    end

    inreplace prefix/"completions/zsh/_m" do |s|
      # Use absolute brew path for zsh completion
      s.sub!(/^\s*local PLUGINS_DIR=.+$/, "local PLUGINS_DIR=#{prefix}/plugins")
    end

    inreplace prefix/"completions/fish/m.fish" do |s|
      # Use absolute brew path for fish completion
      s.gsub!(%r{^\s*set plugins_dir "\$script_dir/plugins"$},
              "set plugins_dir \"#{prefix}/plugins\"")
    end

    # Remove the install script, it is not needed
    (prefix/"install.sh").unlink if (prefix/"install.sh").exist?

    bin.install_symlink "#{prefix}/m" => "m"
    bash_completion.install prefix/"completions/bash/m"
    zsh_completion.install prefix/"completions/zsh/_m"
    fish_completion.install prefix/"completions/fish/m.fish"
  end

  test do
    output = pipe_output("#{bin}/m --help 2>&1")
    refute_match(/.*No such file or directory.*/, output)
    refute_match(/.*command not found.*/, output)
    assert_match(/.*Swiss Army Knife for macOS.*/, output)
  end
end