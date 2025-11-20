class Mdz < Formula
  desc "CLI for the mdz ledger Open Source"
  homepage "https://github.com/LerianStudio/midaz"
  url "https://ghfast.top/https://github.com/LerianStudio/midaz/archive/refs/tags/v3.4.2.tar.gz"
  sha256 "936691212c7a30023455f671be71af01b4dafc4d83301beed38b887df5ba504d"
  license "Apache-2.0"
  head "https://github.com/LerianStudio/midaz.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "484cc8c1836d569d377386889ef169e3843bb602104957e898873baf60d60abf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be21a84b674ebacf2e8b540a5232716faa9fa830ee6de58bbe171f4668f0a35b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7329e10e6438e3737bd35b666d35d8782c7db3f6f3e0daea8327d3be077cec36"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce39c74c13bc7f5ea008e33578f64e106c0878c2aba52219ac739e0df09b82ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2f2faea3413df11250f006f2a48476f069ca8e914f13c6b32bd7ebc8199ede7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e52cb6eb4e64aa437f6c3a9307e4dba16f176b883cb26d79d53cc37a6f48be0"
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