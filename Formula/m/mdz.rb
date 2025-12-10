class Mdz < Formula
  desc "CLI for the mdz ledger Open Source"
  homepage "https://github.com/LerianStudio/midaz"
  url "https://ghfast.top/https://github.com/LerianStudio/midaz/archive/refs/tags/v3.4.7.tar.gz"
  sha256 "d03a4af26f0f1727fc8a835194b747e20754466995efc94fb02e7cd5f24f1b67"
  license "Apache-2.0"
  head "https://github.com/LerianStudio/midaz.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eae2798da396b801c695e6978eb58cb5e0bbf324ea42dae90b4f217626e176be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72ee178fa41be3906334cc09bdbafd3f1e06fafa24ae9ec1e18468c05232dd34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a6de3fe955f6a47f7f5de344e96a30922660bad15835fb4e9e9ed3787dc649c"
    sha256 cellar: :any_skip_relocation, sonoma:        "944c0dd7f07c17c109d1f4a9755aa5c244daa7ebbb4059fa12939e551b3a4ed6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a29bc7b1da823425c04ba436f2b748a7df60c5c3e7b4dab348327e695f9d8a59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "520b220ac4c79235d78f4f307e3186f16fdf10b14acdf22f9284194c142229a0"
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