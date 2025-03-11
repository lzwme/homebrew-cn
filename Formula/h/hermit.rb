class Hermit < Formula
  desc "Manages isolated, self-bootstrapping sets of tools in software projects"
  homepage "https:cashapp.github.iohermit"
  url "https:github.comcashapphermitarchiverefstagsv0.44.2.tar.gz"
  sha256 "d88ba9cb58a9f35670bfee6fa42fb68e1b03b118a61568acef7855030a478c89"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c99770f470688143d715d3e750a978cb2b34ec1644cc7f941d7ed03e12b32c0f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8dc24990b30d21bdfee8aca66fae9912c93095b2019528a5dcca4bb14197ec32"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5f16d57c181e841803caff48b0bcec4afad1568a4951e808842d707af6d1bb04"
    sha256 cellar: :any_skip_relocation, sonoma:        "e994b655e660cbbc8166ffecfac17e7ab5c350325a4bba56bc0cdd794926fb49"
    sha256 cellar: :any_skip_relocation, ventura:       "cfeb00939894d2dedf6abd1831bd7e19ce938068f06b30bb95b36eb8d97bb098"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92315c8a02a25d2d59b9c444bb20720a6bb8bb154d0b8422100f8fa5b08d14a4"
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