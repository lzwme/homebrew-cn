class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https:github.comhirosystemsclarinet"
  # pull from git tag to get submodules
  url "https:github.comhirosystemsclarinet.git",
      tag:      "v2.3.0",
      revision: "7a41c0c312148b3a5f0eee28a95bebf2766d2e8d"
  license "GPL-3.0-only"
  head "https:github.comhirosystemsclarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8d198b49c989dd9b738c96a39dfc399bb05a9cc90a7115d6deb92db69eda2480"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe398f1b9a675c3d87883fbad62baf9b15bf16a1c329bf421e082325a9d915c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8557772479f7a87f88f34a2f867a384f5ef45c6685795b406d6a07403f8ce26e"
    sha256 cellar: :any_skip_relocation, sonoma:         "0c9c022dc6643c8e0623fe6f5eb501f1bb42361ec10cd28dcbe2718408b03fff"
    sha256 cellar: :any_skip_relocation, ventura:        "5e3a02cbb4cb5b3654b91c1be7396d36a58da07674adb1336b2a6c6d2ae2d125"
    sha256 cellar: :any_skip_relocation, monterey:       "64aa24571d78a7e421f9273a8bfb400df6ab9e706ae1d056da2ee04b40415dd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d916d60b5cf0d123ccbf261831c8724c8c3fdfaa3a2e44e50cd348a0cd7db100"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "clarinet-install", "--root", prefix.to_s
  end

  test do
    pipe_output("#{bin}clarinet new test-project", "n\n")
    assert_match "name = \"test-project\"", (testpath"test-projectClarinet.toml").read
    system bin"clarinet", "check", "--manifest-path", "test-projectClarinet.toml"
  end
end