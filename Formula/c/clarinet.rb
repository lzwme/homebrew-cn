class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https:www.hiro.soclarinet"
  url "https:github.comhirosystemsclarinetarchiverefstagsv2.13.0.tar.gz"
  sha256 "2a38ec8ec0bac13cfa0c5b6e16716692cf30c5e47ba47f38462f06b08cdf16d0"
  license "GPL-3.0-only"
  head "https:github.comhirosystemsclarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba8738c0fe7c0492f0eb33e421d0d277ec2a071c501fb90256851abd79859703"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab22e4f92cd1771e01c2b8c7d9abf8b2d8b75dc9dbff9b234b35b849cdb6b2dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1f37b08419a6495b0808886f8908770f3409f3f39bbc93db49ce54cc03b2653c"
    sha256 cellar: :any_skip_relocation, sonoma:        "8afebd168cca4826581d5a5ed902ca376e744ba0b26d44b4f21290aa9c013f5b"
    sha256 cellar: :any_skip_relocation, ventura:       "e5e63ffdabb79318b378a8a113f622db604a04576f26635a5c2fa711f7ddc71d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2133b174aaab46204545a43e3f3ba306c67093c705410556b57c9555a52d48da"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "componentsclarinet-cli")
  end

  test do
    pipe_output("#{bin}clarinet new test-project", "n\n")
    assert_match "name = \"test-project\"", (testpath"test-projectClarinet.toml").read
    system bin"clarinet", "check", "--manifest-path", "test-projectClarinet.toml"
  end
end