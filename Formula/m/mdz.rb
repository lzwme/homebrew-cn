class Mdz < Formula
  desc "CLI for the mdz ledger Open Source"
  homepage "https://github.com/LerianStudio/midaz"
  url "https://ghfast.top/https://github.com/LerianStudio/midaz/archive/refs/tags/v3.3.4.tar.gz"
  sha256 "58d212fceac633daa723e1370f5bfcb4b1a7969cf7d9ffeac8f50b367e2cc341"
  license "Apache-2.0"
  head "https://github.com/LerianStudio/midaz.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "20dcb0cf11459f003ba4bd64eafbaf4507bac3fb768134eaffb8715ffaec2c81"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e6b0dfab14e455e2e77d164d70c7afdf0f48208a2389ad68ac5c1e25d636263"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e20dd353a265d9f324b438aed3d92e42b78ac068c1a9bf622a7852fec1a9ccc"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d0a08a6fa1e08252fc19a4b5892f4c44ddf5d61e886dbcb4788293c0ee96028"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "641701d1d9bcea5d5e78fd9df76b252f79a0eb7f01cf5771e0c153287b973e3a"
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