class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https:www.hiro.soclarinet"
  url "https:github.comhirosystemsclarinetarchiverefstagsv2.11.2.tar.gz"
  sha256 "e1bd51d80dec29b67c144761d1afbd99f1289a822a60bd86c1e8489147dcc404"
  license "GPL-3.0-only"
  head "https:github.comhirosystemsclarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a3c79e89409ff0022f5839aeb8353699a99d30d147670c021e8065ebe63f2d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "575448cc006e65fe36e6344ac6c7b73c68127b595cb5b5c22fbc372c0cf0d624"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2f74491e32e150828e35841184bce68c3389c8dce18daa18e91dd4a59e82170a"
    sha256 cellar: :any_skip_relocation, sonoma:        "c15fe3d0138789be0bd529d21d2b32d1c6407f40a35a9f9bd1b2024deb416014"
    sha256 cellar: :any_skip_relocation, ventura:       "06a889b767424c97b100e57890fcd0229f6be7450bf7ac8e760d12a960cb0116"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf62976b0fd58db62e452f689bbc377a1d9a7ce42eb5369d02f053677f1db986"
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