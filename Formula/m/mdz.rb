class Mdz < Formula
  desc "CLI for the mdz ledger Open Source"
  homepage "https:github.comLerianStudiomidaz"
  url "https:github.comLerianStudiomidazarchiverefstagsv1.43.0.tar.gz"
  sha256 "b9073011e4c6fe820aed0fc9d93cf35d0efa3a2bdfa7242bd706d57069428124"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dcbc1c7e824575941dc44dc785911255e14dfaa6b3a2598ec35fbd2094ef03da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dcbc1c7e824575941dc44dc785911255e14dfaa6b3a2598ec35fbd2094ef03da"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dcbc1c7e824575941dc44dc785911255e14dfaa6b3a2598ec35fbd2094ef03da"
    sha256 cellar: :any_skip_relocation, sonoma:        "81b2c5bae7e96ce0ff2c716850382c9c1e1f8a4f3f9a16cf947d16c0b7ef8982"
    sha256 cellar: :any_skip_relocation, ventura:       "81b2c5bae7e96ce0ff2c716850382c9c1e1f8a4f3f9a16cf947d16c0b7ef8982"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c784f3a504b4867783002523d17397c13f64a4789c185fc898ff57f42206958"
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