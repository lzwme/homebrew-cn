class Mdz < Formula
  desc "CLI for the mdz ledger Open Source"
  homepage "https:github.comLerianStudiomidaz"
  url "https:github.comLerianStudiomidazarchiverefstagsv2.0.0.tar.gz"
  sha256 "e4a6e6f3ce9b7bfa270afc5727f4a958e59ec63ef10be545a2dfde489bc83230"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98b7363013b45ef41dc5c653b4f4c4950ef87b07dd719a76d730dc964c0ea703"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "394b9de1027da7c5c5cc526fc8df1d5121e7fd56fca21cada8ff73a256a58d0b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5b71d03384c818c6aa31c94c9d694f5a196a108aa98e91870fdb31360f82d33d"
    sha256 cellar: :any_skip_relocation, sonoma:        "6698792e17e7c666b618c712db956e2de83664b37d9d22dc9e911901e68f6f93"
    sha256 cellar: :any_skip_relocation, ventura:       "ef290e9a7e2cb6ce4ad55367cfa517f057320dba4216faed06945bafaf8d5475"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb1648235c7c681c47a36e926bd5d685cdb231dbdbe9f5b36349add7d18f1c5c"
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