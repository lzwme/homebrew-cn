class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https:www.hiro.soclarinet"
  url "https:github.comhirosystemsclarinetarchiverefstagsv2.14.0.tar.gz"
  sha256 "bca76483b8f17b0cc698e53adca1c815007a835508bd6f7bda4b405c99b1a9af"
  license "GPL-3.0-only"
  head "https:github.comhirosystemsclarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa0afdcdd838a83909b33083ce655261c263d5c38a24b00bdaadbf4b18564dac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d434d1f2e2c5d492b1087b5dc2fbee3f39df47bd493bc4c9679f2c4b9d95b570"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3a1ae161d3bbf9c6637b630106a6df75993392801d2a0b308b0b445349794139"
    sha256 cellar: :any_skip_relocation, sonoma:        "dba189e721f24e8226a024ce40ec1e9444df37d464e0ed4e8e92d046d3fbf746"
    sha256 cellar: :any_skip_relocation, ventura:       "2c09da49bfce9ab88d4cd1ce616163aaf50c2dea5e61a5951d52a1279ac7089d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c71e4e0ab4d99879d058df77b05701501410375e592f5cfd16cceef30c1bace"
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