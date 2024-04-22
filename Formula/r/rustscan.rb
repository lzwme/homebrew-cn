class Rustscan < Formula
  desc "Modern Day Portscanner"
  homepage "https:github.comrustscanrustscan"
  url "https:github.comRustScanRustScanarchiverefstags2.2.2.tar.gz"
  sha256 "bae70efb414b8d809571773b8ba0240c5d06fe1199ffb187510cfabff936ac75"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "897cb7a5a57bbd15635a457fd9eef062be359f3d368fe4a56fb3e54c829c6852"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca34c76fa745276dcd37ef7f050a4b270b31f102bc00b1c08bd70138de6d07ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc8653d3c17f2a2420dcd195850842ebf9eef47d95fb6d52258756fa89a9cd6a"
    sha256 cellar: :any_skip_relocation, sonoma:         "14b70459393eb0dbe5cf4af396edd841319568ed40a7e8c4431aa7097b054c3d"
    sha256 cellar: :any_skip_relocation, ventura:        "5006b76c6fbd2b71935866d0bc9eb5048c310e0fa0d7f4f42f21463b220fe25d"
    sha256 cellar: :any_skip_relocation, monterey:       "ceb8aa30004479988b449d62c92480ca8b9248e0d38b75b4586b5790b7a7a55c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fee42af959aa18a053077ef08ed3b69c985567067655ed7ff5853cf99fbebf7"
  end

  depends_on "rust" => :build
  depends_on "nmap"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    refute_match("panic", shell_output("#{bin}rustscan --greppable -a 127.0.0.1"))
    refute_match("panic", shell_output("#{bin}rustscan --greppable -a 0.0.0.0"))
  end
end