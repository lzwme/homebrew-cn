class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https:github.commongodbkingfisher"
  url "https:github.commongodbkingfisherarchiverefstagsv1.14.0.tar.gz"
  sha256 "7e9053c8436d2833059c8ce6e798c0872a3f8c0db9ade8fd58ff5614afd02261"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0930384427c97a52f6589e25afaf2a005fb1e56a0faa0bc3ab6d147426321d72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f8accd617f642602e95b58d0d042c49e9993280bf0f047e8b6032ecbaa0276d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9e32d18b41fe6c0a1ebf54773c93f93d73c1f1c2266c56c586a2a5f374337456"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d2a1741b31e9585395f49395b34fb7cad0c08a3bc00fc779b2a2993c4929139"
    sha256 cellar: :any_skip_relocation, ventura:       "939349343bfccc5418b912bad272544e4230ca620d35a8548a0a0d37736b5719"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac370a3517d4a03774b47a19f551c8b4417bb178f26e0672c9e3cdcc3d1448a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad846aa35e623bfea51e24a5742790ecf2e8c89ec63117fefaa8083bdfd99f42"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features", "system-alloc", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}kingfisher --version")

    output = shell_output(bin"kingfisher scan --git-url https:github.comhomebrew.github")
    assert_match "|Findings....................: 0", output
  end
end