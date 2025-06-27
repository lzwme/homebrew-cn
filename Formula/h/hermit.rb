class Hermit < Formula
  desc "Manages isolated, self-bootstrapping sets of tools in software projects"
  homepage "https:cashapp.github.iohermit"
  url "https:github.comcashapphermitarchiverefstagsv0.44.10.tar.gz"
  sha256 "45b5c9d9baa945a368dcbd996736f41207fb2daa7a348edecbff8856022b1595"
  license "Apache-2.0"
  head "https:github.comcashapphermit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b61a536b6cdd96d6c6d19a0978b77d3d9b94944403e4f12e6f11a7ebe2a2d40b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09d927cf3a05830aca4c20f70fb37265b703f71cce25d05db1bc29d004bdbf6c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7882643db1096b06e18f7c3dab374a76f2d3bf3bf3beec397f125fad8886876d"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d8251190e2a2fd9173a48e9c2a99d3d55f0f17145d4e3377701d80803945cfd"
    sha256 cellar: :any_skip_relocation, ventura:       "69eab62946c1483a2cc25a5fbe57533422853e481c5fe8ef873c58944b756b7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a00b9ca0d96b0d6c0adc68b1b3fb91463cb08a0f558c9392df9fcae4550ed0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60ecad7ebff4a9fd5d35c6517b90bc7a4b61494b59bb68797a73c892f1655049"
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