class Hermit < Formula
  desc "Manages isolated, self-bootstrapping sets of tools in software projects"
  homepage "https:cashapp.github.iohermit"
  url "https:github.comcashapphermitarchiverefstagsv0.44.4.tar.gz"
  sha256 "99dcc97d40293354df6f0bc2ea95d69fc3f0a7407ef8f3d726af3636e58aa265"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd559a9dcc08ebe1ac2b500d6e1a1930538880b28a8ad71f79124f96ece80c18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1484934ba7a694dd215e7dcc97ed044e93545f7dbf25d4a06121b8c45a46f34e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b9a2bbe166b95a64b40e424b9c704e8236d8e3a534fbe86250f3e5e9f25ae523"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2f954306a722d7648702fb77bc8da955196536c83f9be7941aa28db0f897f37"
    sha256 cellar: :any_skip_relocation, ventura:       "42f228e29f91afbe7264698c774d0aca7404c9cc06529d1bbb338de5d168c386"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6954aa2c0d1d72abb89fd89e17354c9273b61526e903037a928e05c8aeff56f6"
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