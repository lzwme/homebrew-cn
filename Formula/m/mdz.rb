class Mdz < Formula
  desc "CLI for the mdz ledger Open Source"
  homepage "https://github.com/LerianStudio/midaz"
  url "https://ghfast.top/https://github.com/LerianStudio/midaz/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "dd19ed3cadb6468ab1cdacc4ac710a393f5dc16d3e95e0aa2862936f9839b252"
  license "Apache-2.0"
  head "https://github.com/LerianStudio/midaz.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d4c804d545671437d702b1a6f989c32c1229df1aaa6a0e84bcc103ebfd6d8617"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef6be8a35d7c4284886fc3488662a981e529ea4e0637feda950de065243c0c37"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "827d01c8d736491566a945d29581a85e7fba3907c9780530767c8175fb7340b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "9174d26e42ad46d9c4b2589a0e48c6ee3160307d1ae518d33fe34787ef54a84c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88e586adced15dc5d62fc7cbac6a2977819213ca2295c97f2ecfe2a8dabee0e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f9ed7b904705e6d600879c5f87fe7e51bd8dcae12b74fee7fdd451312adbe51"
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