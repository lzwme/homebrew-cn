class Mdz < Formula
  desc "CLI for the mdz ledger Open Source"
  homepage "https:github.comLerianStudiomidaz"
  url "https:github.comLerianStudiomidazarchiverefstagsv1.50.0.tar.gz"
  sha256 "3615bb579c5e05382848e19f91c6c9b8477d0c65a991e94ecee5e5d98b725f67"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b84d9d696a20de72b0c56b3d2b99a625503c461b13fe0d08631fa678da63f2b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf1ed05342c719caf168de8185d6815d18332790280187711bfaaf93674da08d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bc990e143ab9daa91bb5b478b778e9520bcebfb540ee8e960a22e92ce385d657"
    sha256 cellar: :any_skip_relocation, sonoma:        "17adf8e55c1d66b8b9379155257a5e4345cd8a6a2c46df73adf00c23fa5af9ed"
    sha256 cellar: :any_skip_relocation, ventura:       "1829bb92146161bc769dfe6c8c10b4c1973fc0ef584fdcced441ce5d92aff931"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46dc1323d91bb20d78cb0bf35b055096843473fc051b27b9b1c63f6d1613caaa"
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