class Mdz < Formula
  desc "CLI for the mdz ledger Open Source"
  homepage "https://github.com/LerianStudio/midaz"
  url "https://ghfast.top/https://github.com/LerianStudio/midaz/archive/refs/tags/v3.4.4.tar.gz"
  sha256 "08130058f06c21271ebf48c56bbe18a3a9be304fe8e2f4edfb83c75f19b378ad"
  license "Apache-2.0"
  head "https://github.com/LerianStudio/midaz.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47837a389688b6279aebf3673bb640573613f506ef1d25184ced41e8551f8ab4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "900b3a7e732fa2c59c5d3a8e8197e86827366508a919872b6795c2957e354b7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ed3508f567599a35522ec6b5091d4f0a26caedfb4699e39e630dd9a1929e01b"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad968ab47bba2aba9c6cfbb6b2f179597b8af9e8595f6f00c0bbf65b04fac6d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc8412dc27f1ed0124b171a241565298e748b31135eedc78ef122c8fde48d149"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "313629ddb8ff3ab705a40b2edcd45e2f39e8bdbaf76145a021d496a3ddae3c32"
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