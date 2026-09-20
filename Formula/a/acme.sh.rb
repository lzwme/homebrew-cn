class AcmeSh < Formula
  desc "ACME client"
  homepage "https://github.com/acmesh-official/acme.sh"
  url "https://ghfast.top/https://github.com/acmesh-official/acme.sh/archive/refs/tags/3.1.5.tar.gz"
  sha256 "a5e5b61bf98464fd7bf9925951b97e9ed8c127e041d3b8e9703d2360cd6e19b6"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2e0d35ef65443913d9bbca1695224c87c055f8f40c836d6bc5ff925d07dca2cd"
  end

  deny_network_access!

  def install
    libexec.install [
      "acme.sh",
      "deploy",
      "dnsapi",
      "notify",
    ]

    bin.install_symlink libexec/"acme.sh"
    bash_completion.install "acme.sh.completion" => "acme.sh"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/acme.sh --version")

    expected = /Main_Domain\s*KeyLength\s*SAN_Domains\s*Profile\s*CA\s*Created\s*Renew/i
    assert_match expected, shell_output("#{bin}/acme.sh --list")
  end
end