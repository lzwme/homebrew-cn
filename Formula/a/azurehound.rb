class Azurehound < Formula
  desc "Azure Data Exporter for BloodHound"
  homepage "https://github.com/SpecterOps/AzureHound"
  url "https://ghfast.top/https://github.com/SpecterOps/AzureHound/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "1c5c7b9dea1da30416e740938ce720f140d2ed0e48be873d6869dd24db570fea"
  license "GPL-3.0-or-later"
  head "https://github.com/SpecterOps/AzureHound.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b7c3516fff0e6375170a72b20f0099c436b3b212105701c4e88b9e3e3caac2e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7c3516fff0e6375170a72b20f0099c436b3b212105701c4e88b9e3e3caac2e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7c3516fff0e6375170a72b20f0099c436b3b212105701c4e88b9e3e3caac2e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "47efc7e29b9b241b23ac6d7ea3e1c6f552530c70449d6b7e5d26c18bd99b921f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3e44cf3d3f3e697db1cad4e0dfe68aa242d05b6a6da8a1019b6cc5272745337"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0ba49efcb770b1b25235219d13cfd86e11cc0c3945df2cd379375663c82ebaf"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/bloodhoundad/azurehound/v2/constants.Version=#{version}")

    generate_completions_from_executable(bin/"azurehound", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azurehound --version")

    assert_match "No configuration file", shell_output("#{bin}/azurehound list 2>&1", 1)
  end
end