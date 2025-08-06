class Mdz < Formula
  desc "CLI for the mdz ledger Open Source"
  homepage "https://github.com/LerianStudio/midaz"
  url "https://ghfast.top/https://github.com/LerianStudio/midaz/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "34d76cea270969d2ea636b6b779dec3775b368422487da98d2c80bb2149ce432"
  license "Apache-2.0"
  head "https://github.com/LerianStudio/midaz.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd83654b94dc2c95c9db5b53d5aeb8896289f8fc960de32ff12634db2a51cddf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25d11e856f8914089df7433cc646808ee57b926901f8d1494bc604a081a3126d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5b50b3b98829e37db436be17162e9db8ba897f8135498cb126a07ffa6346295b"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf1e9899f0790587e97c3f657402dbfff185e3b7e03ba9e0b032e73d9e33a0af"
    sha256 cellar: :any_skip_relocation, ventura:       "3dae7a4e8af52dd73b1259331b5a738a7ae47e162bca44db6bf83419620d56f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a4e66c1205de96f66c3aac36a38cdc2b29eb1602a919b420caf3ab7626d02d9"
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