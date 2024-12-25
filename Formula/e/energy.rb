class Energy < Formula
  desc "CLI is used to initialize the Energy development environment tools"
  homepage "https:energye.github.io"
  url "https:github.comenergyeenergyarchiverefstagsv2.5.1.tar.gz"
  sha256 "c492bbc5ce5fd7e2ef7e5bd2225d0f844da5be51d63cdc4a5b7df73fc24b2e17"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e62fc9c1a6c58038226e028cd688ef3b2f21b49fe156a13f51f30522348c7951"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e62fc9c1a6c58038226e028cd688ef3b2f21b49fe156a13f51f30522348c7951"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e62fc9c1a6c58038226e028cd688ef3b2f21b49fe156a13f51f30522348c7951"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b3fc139d84fe21b1903ba4e9ce42fb1232572652856e7d91a89797ee5c9840b"
    sha256 cellar: :any_skip_relocation, ventura:       "4b3fc139d84fe21b1903ba4e9ce42fb1232572652856e7d91a89797ee5c9840b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e31a37661e5c5249d609858447268f60937b41975741247c43c0c6e322bdced8"
  end

  depends_on "go" => :build

  def install
    cd "cmdenergy" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
  end

  test do
    output = shell_output("#{bin}energy cli -v")
    assert_match "CLI Current: #{version}", output
    assert_match "CLI Latest : #{version}", output

    assert_match "https:energye.github.io", shell_output("#{bin}energy env")
  end
end