class Mdz < Formula
  desc "CLI for the mdz ledger Open Source"
  homepage "https://github.com/LerianStudio/midaz"
  url "https://ghfast.top/https://github.com/LerianStudio/midaz/archive/refs/tags/v3.4.1.tar.gz"
  sha256 "1db01b94760db5ce66ad0109113f97a5f4f06f3ad68642c83d371bf15fd4c903"
  license "Apache-2.0"
  head "https://github.com/LerianStudio/midaz.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e3069fe9758c55c750ca879ef4cd2a75341e9b976dfdeca079140803818a0d89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "310303093f2f28ae11eeebf648ea5ad11080851786e935a082e0ab23ced0cfe2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c9bafd24c0c573e3c14144066094269056eff33844b171e0dd79cedbbfe5638"
    sha256 cellar: :any_skip_relocation, sonoma:        "23aa00d43c0d3ece23dffbda36a0d03c27cfa81ea3237db1429201233f02ddd8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dbb01f95bd3377d747f902bfc6ae5161b3ff9a305b1c9c343d5c28e81fe4c42c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c8019928de853025002031b55c48b5424d4e1132c0791fcb3eea9c8f6e3d21b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/LerianStudio/midaz/v3/components/mdz/pkg/environment.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./components/mdz"

    generate_completions_from_executable(bin/"mdz", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match "Mdz CLI #{version}", shell_output("#{bin}/mdz --version")

    client_id = "9670e0ca55a29a466d31"
    client_secret = "dd03f916cacf4a98c6a413d9c38ba102dce436a9"
    url_api_auth = "http://127.0.0.1:8080"
    url_api_ledger = "http://127.0.0.1:3000"

    output = shell_output("#{bin}/mdz configure --client-id #{client_id} " \
                          "--client-secret #{client_secret} --url-api-auth #{url_api_auth} " \
                          "--url-api-ledger #{url_api_ledger}")

    assert_match "client-id:       9670e0ca55a29a466d31", output
    assert_match "client-secret:   dd03f916cacf4a98c6a413d9c38ba102dce436a9", output
    assert_match "url-api-auth:    http://127.0.0.1:8080", output
    assert_match "url-api-ledger:  http://127.0.0.1:3000", output
  end
end