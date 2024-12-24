class Mdz < Formula
  desc "CLI for the mdz ledger Open Source"
  homepage "https:github.comLerianStudiomidaz"
  url "https:github.comLerianStudiomidazarchiverefstagsv1.38.0.tar.gz"
  sha256 "82c54649e7051e32cbf7e7d1727525319222caa463c362fbaec5a13b239f57cf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7d2073bbcd0ba25d74356ba00a442a1a78653c5f098c7d450472308d7e92b22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7d2073bbcd0ba25d74356ba00a442a1a78653c5f098c7d450472308d7e92b22"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c7d2073bbcd0ba25d74356ba00a442a1a78653c5f098c7d450472308d7e92b22"
    sha256 cellar: :any_skip_relocation, sonoma:        "07d6e0016844f5f8ec0d1d365c4787df998875d0460cd2b3b9ecf5b8ae946985"
    sha256 cellar: :any_skip_relocation, ventura:       "07d6e0016844f5f8ec0d1d365c4787df998875d0460cd2b3b9ecf5b8ae946985"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "466f01a2d10c24845d02143dafe1e3fc8267ee85253d7870c7a5a4f502ca6060"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comLerianStudiomidazcomponentsmdzpkgenvironment.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".componentsmdz"
  end

  test do
    assert_match "Mdz CLI #{version}", shell_output("#{bin}mdz --version")

    client_id = "9670e0ca55a29a466d31"
    client_secret = "dd03f916cacf4a98c6a413d9c38ba102dce436a9"
    url_api_auth = "http:127.0.0.1:8080"
    url_api_ledger = "http:127.0.0.1:3000"

    output = shell_output("#{bin}mdz configure --client-id #{client_id} " \
                          "--client-secret #{client_secret} --url-api-auth #{url_api_auth} " \
                          "--url-api-ledger #{url_api_ledger}")

    assert_match "client-id:       9670e0ca55a29a466d31", output
    assert_match "client-secret:   dd03f916cacf4a98c6a413d9c38ba102dce436a9", output
    assert_match "url-api-auth:    http:127.0.0.1:8080", output
    assert_match "url-api-ledger:  http:127.0.0.1:3000", output
  end
end