class Azurehound < Formula
  desc "Azure Data Exporter for BloodHound"
  homepage "https://github.com/SpecterOps/AzureHound"
  url "https://ghfast.top/https://github.com/SpecterOps/AzureHound/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "4badf25f90fe99fe07e240fa01a6ab49824d80c70177bd882f46d845fc0251be"
  license "GPL-3.0-or-later"
  head "https://github.com/SpecterOps/AzureHound.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9427d04e0b24a8915fc35f8766b62275953c152302d8c77ec68de34cfd3134aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9427d04e0b24a8915fc35f8766b62275953c152302d8c77ec68de34cfd3134aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9427d04e0b24a8915fc35f8766b62275953c152302d8c77ec68de34cfd3134aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c7f66475608ec44aa3e36fab355afe584790f5f1365d3a60641d321d926d74c"
    sha256 cellar: :any_skip_relocation, ventura:       "5c7f66475608ec44aa3e36fab355afe584790f5f1365d3a60641d321d926d74c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "730c65b311dec181e4d987304111eb6c2bab6770d5ce7ecc335a9e7ec0d6f678"
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