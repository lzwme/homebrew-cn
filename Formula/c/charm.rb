class Charm < Formula
  desc "Tool for managing Juju Charms"
  homepage "https:github.comjujucharmstore-client"
  url "https:github.comjujucharmstore-clientarchiverefstagsv2.5.2.tar.gz"
  sha256 "3dd52c9a463bc09bedb3a07eb0977711aec77611b9c0d7f40cd366a66aa2ca03"
  license "GPL-3.0-only"
  head "https:github.comjujucharmstore-client.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e6863b87f5141d695d361b1b0b7c68d9ab4edf710935a82d1839e0d7890cd2e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "76693903d37a9dc93095fd09c496c21d0651a71f39b1abbce782519ea2859f6c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2235de1789688bdc50e5e8443b4748a52dd36c7887e4d6b20d9e41417c5cdad0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f0cac05e7c2c0990fd6c186405a13c832ff84b47fb77c2928aab7c29548b670"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "406f7bc14f44bd5462dde85da36d37cf5218ba7db06f7e27121ca2cc504d4eb8"
    sha256 cellar: :any_skip_relocation, sonoma:         "537c03caa99579d5141651ef25365ee5f0af06840beb5c72926cef99826d4039"
    sha256 cellar: :any_skip_relocation, ventura:        "f7ed8885d301a9b4bba15d657de9ee132dbb2603de8367523b0d9d41750bb0ab"
    sha256 cellar: :any_skip_relocation, monterey:       "117bca978b5d65dc38f4e63d54ca0ef24f3b3e8cc808c97488854afb3a48a2ba"
    sha256 cellar: :any_skip_relocation, big_sur:        "6c5e1f0af81ab86774fe87eb7c793c390386cc45b255348dc6467ad030f740d8"
    sha256 cellar: :any_skip_relocation, catalina:       "2cfca124d8f2bdc973797c2a290b36f87e4d8d4d39e7ebb4358b552e12ac89eb"
    sha256 cellar: :any_skip_relocation, mojave:         "a50370e9787fc797efc1b7c0dcc45fff5fd2ee02fea66e2d7db5d132c2153665"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "623e2d62e1dc1210de466ff4e4ea1d8e0c8ea059dbdc491ff5b8f3ec1cc9603e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, ".cmdcharm"
  end

  test do
    assert_match "show-plan           - show plan details", shell_output("#{bin}charm 2>&1")

    assert_match "ERROR missing plan url", shell_output("#{bin}charm show-plan 2>&1", 2)
  end
end