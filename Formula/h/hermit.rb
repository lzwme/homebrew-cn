class Hermit < Formula
  desc "Manages isolated, self-bootstrapping sets of tools in software projects"
  homepage "https:cashapp.github.iohermit"
  url "https:github.comcashapphermitarchiverefstagsv0.44.3.tar.gz"
  sha256 "3fc3ba4b6578d513f72a7366a9247b09e1f73c4fe5b8cf0e50376838a93615e8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "63599ef4c71fcf45d776447ccf5a0e20da62314fff20da21a048c6705a5536cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "860b8707b388b7a2bd39ee62c053461cc483b59ab003f11748058f8877f5415f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ebf1450f34b6c4ba6eed2757551c5cf0436e65ea91a74c91597f13b9b15b70dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "2337e55d06bd6d71e5998a3aa76b00dc8973dc9bd510ad8e272be971a12f6256"
    sha256 cellar: :any_skip_relocation, ventura:       "913fe1cd98795430936ac21f2b41c7f73a489db98019ea4776f4fb62e8ed8885"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00602b796943420000a8f6272ed172bee83e7c20db25cb2030180debac701cd9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.channel=stable
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdhermit"
  end

  def caveats
    <<~EOS
      For shell integration hooks, add the following to your shell configuration:

      For bash, add the following command to your .bashrc:
        eval "$(test -x $(brew --prefix)binhermit && $(brew --prefix)binhermit shell-hooks --print --bash)"

      For zsh, add the following command to your .zshrc:
        eval "$(test -x $(brew --prefix)binhermit && $(brew --prefix)binhermit shell-hooks --print --zsh)"
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}hermit version")
    system bin"hermit", "init", "."
    assert_path_exists testpath"binhermit.hcl"
  end
end