class Mdz < Formula
  desc "CLI for the mdz ledger Open Source"
  homepage "https:github.comLerianStudiomidaz"
  url "https:github.comLerianStudiomidazarchiverefstagsv1.44.0.tar.gz"
  sha256 "3ac5d949f75bd4a2d69540f0bb8d728f0af1a75d4fd19bec396f28f58909674c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dfa8b103d420524d0fbf946fcb81ca4e48746e0cd12e6b01efc44efcce173c14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dfa8b103d420524d0fbf946fcb81ca4e48746e0cd12e6b01efc44efcce173c14"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dfa8b103d420524d0fbf946fcb81ca4e48746e0cd12e6b01efc44efcce173c14"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd378e237695e016bc1550cab4790fd7e2ea47db6fc1a99fe0c2ea9a97dbd91f"
    sha256 cellar: :any_skip_relocation, ventura:       "dd378e237695e016bc1550cab4790fd7e2ea47db6fc1a99fe0c2ea9a97dbd91f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a23a50f7464ba174d757fdfc2fc426e5f6e26707ceab3d2bf6d7dcf8d19a535"
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