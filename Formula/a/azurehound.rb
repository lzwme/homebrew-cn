class Azurehound < Formula
  desc "Azure Data Exporter for BloodHound"
  homepage "https:github.comSpecterOpsAzureHound"
  url "https:github.comSpecterOpsAzureHoundarchiverefstagsv2.3.0.tar.gz"
  sha256 "13e056268ee5818e0431550fd4e7d54f73e3d97b17689c8876923996d99aee16"
  license "GPL-3.0-or-later"
  head "https:github.comSpecterOpsAzureHound.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "834bf603ac5d939d7db5a5c65cfde02b219eee7b5fc07aa907b6a52dffd4782f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "834bf603ac5d939d7db5a5c65cfde02b219eee7b5fc07aa907b6a52dffd4782f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "834bf603ac5d939d7db5a5c65cfde02b219eee7b5fc07aa907b6a52dffd4782f"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ad8cdf4ac0b95459f2f38e18cfd395fd942e42de0f6e26f817ab241759e0a7d"
    sha256 cellar: :any_skip_relocation, ventura:       "0ad8cdf4ac0b95459f2f38e18cfd395fd942e42de0f6e26f817ab241759e0a7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad864f1ba0bc89254ba8dee3a3dada0754b2948a89288840adda7f9c38365907"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.combloodhoundadazurehoundv2constants.Version=#{version}")

    generate_completions_from_executable(bin"azurehound", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}azurehound --version")

    assert_match "No configuration file", shell_output("#{bin}azurehound list 2>&1", 1)
  end
end