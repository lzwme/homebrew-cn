class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https:www.hiro.soclarinet"
  url "https:github.comhirosystemsclarinetarchiverefstagsv3.0.1.tar.gz"
  sha256 "97feea2fe5b32262c90a34124c7becab7a2fbbe8a0ff409b325ed7d229abd47a"
  license "GPL-3.0-only"
  head "https:github.comhirosystemsclarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9a130f8e651f43fb17132145980c40e6715fc594d4d6875c9c2cfaa26fbde37"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f54da2888266a45097d8fd8981eb654e7cf15424481c4a49ae83c2564af09088"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "341256a4b48376a8ea9e97c4bfc834313f8403d92ed057e20107793d24f5567c"
    sha256 cellar: :any_skip_relocation, sonoma:        "72708e1f87cbf537f67e948aea694a2e2d9e85d3d5983879049c5882509086ba"
    sha256 cellar: :any_skip_relocation, ventura:       "d221bd62bcb1c138b26c562edb9d5a61546124188a42241835caad04ea011128"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "671ed97a8287eba1c8b61f9989804488e575ec59a5b2c37b4acb2cbb2554ece2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc300665c815e442f35f3ae1db7cf325557079c8a881a4e5e5ea2b92839924a2"
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