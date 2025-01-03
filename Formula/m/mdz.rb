class Mdz < Formula
  desc "CLI for the mdz ledger Open Source"
  homepage "https:github.comLerianStudiomidaz"
  url "https:github.comLerianStudiomidazarchiverefstagsv1.42.0.tar.gz"
  sha256 "445efe4264b3d067b05791b0b3fc12f0dfb2c15fd056db8234161e083622c95d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5cc8805ae5fa2a7dd7f968e4751ddae0a304d775ad03847a7785b8cf13839a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5cc8805ae5fa2a7dd7f968e4751ddae0a304d775ad03847a7785b8cf13839a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d5cc8805ae5fa2a7dd7f968e4751ddae0a304d775ad03847a7785b8cf13839a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c4a45996f14c41fbdbaf295ea5a6bbb765a58e84b65b2a969e3b4e48f77ab5d"
    sha256 cellar: :any_skip_relocation, ventura:       "8c4a45996f14c41fbdbaf295ea5a6bbb765a58e84b65b2a969e3b4e48f77ab5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1cabf52558652ddcafd0d014568b1ee28796166494a4070069d6af377b973b38"
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