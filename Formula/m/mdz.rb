class Mdz < Formula
  desc "CLI for the mdz ledger Open Source"
  homepage "https://github.com/LerianStudio/midaz"
  url "https://ghfast.top/https://github.com/LerianStudio/midaz/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "80fdbd68d8eb22956df7f065233d44494f186368b22d57b6bb48c161da258593"
  license "Apache-2.0"
  head "https://github.com/LerianStudio/midaz.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6028d9c7c30d17098de6b8dd756561b0125421f6509862d650b6c5d57ace1808"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3af4a45e6732cfb225d0c2dbabc06a038c16d247d44d24a925b3aecea5e292fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f48a811fdbab5a9704ac86a6a72f6ecfa8683d56b72a917dbb88605fb3fd544"
    sha256 cellar: :any_skip_relocation, sonoma:        "081e9abca8c5d7064e668ac187b4fa1a6e3fe01d7b3243772b73db0d49e1fee7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "487d3b6e3d6960823005464ca60446655719bdd72c6951117d509e716e76e3a4"
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