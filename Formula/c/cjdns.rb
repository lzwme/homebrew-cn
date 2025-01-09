class Cjdns < Formula
  desc "Advanced mesh routing system with cryptographic addressing"
  homepage "https:github.comcjdelislecjdns"
  url "https:github.comcjdelislecjdnsarchiverefstagscjdns-v22.1.tar.gz"
  sha256 "3fcd4dcbfbf8d34457c6b22c1024edb8be4a771eea34391a7e7437af72f52083"
  license all_of: ["GPL-3.0-or-later", "GPL-2.0-or-later", "BSD-3-Clause", "MIT"]
  head "https:github.comcjdelislecjdns.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dad7a92383088d864b11ebfbef03b9ea181c3e89d0c38c804d895035de1a9b74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7c7ed9f1030ae11d154c8b56ecbf1960fe592c0b40ea624bd27ac593ffeead3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "87f5189b5d62e3cd6ab280ac7b4a36c9010fbe609b430de711f4b3bdc91ff0ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e182079b505d888dd89e0b828adea13b426b51cfdfc54364ef01341671efe43"
    sha256 cellar: :any_skip_relocation, ventura:       "939b5ef351d3ec8cb836663699f5dcdd572dcde5d9714478d3fc56fdc31b56c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d720c9e5a2d4070720a817659ee69b25c14afbd725d772a9018bebb084a4ac75"
  end

  depends_on "node" => :build
  depends_on "rust" => :build

  def install
    system ".do"
    bin.install "cjdroute"
    bin.install "cjdnstool"

    man1.install "docmancjdroute.1"
    man5.install "docmancjdroute.conf.5"
  end

  test do
    sample_conf = JSON.parse(shell_output("#{bin}cjdroute --genconf"))
    assert_equal "NONE", sample_conf["admin"]["password"]

    help_output = shell_output("#{bin}cjdnstool --help")
    assert_match "cexec", help_output
  end
end