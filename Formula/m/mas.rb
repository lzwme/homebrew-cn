class Mas < Formula
  desc "Mac App Store command-line interface"
  homepage "https:github.commas-climas"
  url "https:github.commas-climas.git",
      tag:      "v1.8.7",
      revision: "4405807010987802c0967bbf349c08808062b824"
  license "MIT"
  head "https:github.commas-climas.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68ed9001ddde79937324927854abee8cb2f6b9852411bb0c04a9cf636eba1af9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "948cdc20e4ea7bf933d6a13e8981bb4d69f125d5e1023ba2074cd7c625798ef5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "33805511f2b3ff2e93ce76767007b14125cc84ee18d522b5a2a4ed6b12133f81"
    sha256 cellar: :any_skip_relocation, sonoma:        "8cc915dc106cf574cd29181c2e6ae776ced01f22222b40b55386a0e9e8c234e0"
    sha256 cellar: :any_skip_relocation, ventura:       "62efe80d665c29cc8cb98c00279b3f30e91d8746886b31a85dd831944ebffbee"
  end

  depends_on xcode: ["14.2", :build]
  depends_on :macos

  def install
    system "scriptbuild", "--disable-sandbox"
    bin.install ".buildreleasemas"

    bash_completion.install "contribcompletionmas-completion.bash" => "mas"
    fish_completion.install "contribcompletionmas.fish"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}mas version").chomp
    assert_includes shell_output("#{bin}mas info 497799835"), "Xcode"
  end
end