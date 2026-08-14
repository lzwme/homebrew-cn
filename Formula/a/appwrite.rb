class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://ghfast.top/https://github.com/appwrite/sdk-for-cli/archive/refs/tags/26.1.0.tar.gz"
  sha256 "902bce1847130f00940736c5cf23d53c9162979644e9a7d8212a655d48a5fee5"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "178c0a2d4e41eb032a686de5f86033c1fe2af40e121684badbc2f8dff5c81ff0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "178c0a2d4e41eb032a686de5f86033c1fe2af40e121684badbc2f8dff5c81ff0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "178c0a2d4e41eb032a686de5f86033c1fe2af40e121684badbc2f8dff5c81ff0"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c85c8e32b3923cc116cf753ac8e14410d3b87fd2fd355e4ee5dc3010c16b0aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bfb0bc4854b24312fee9404843d65fff0b671c788193374fd5a8628e6e00612c"
    sha256 cellar: :any,                 x86_64_linux:  "e910bdf5d1daa7da1798d4cf543cfbc11f19a5c4b96cb32664a9783ffa718ad2"
  end

  depends_on "go" => :build

  def install
    # https://github.com/appwrite/sdk-for-cli/blob/4399a3321898f40cf982acbd4859d506c9d4d9f4/.goreleaser.yaml#L19-L22
    system "go", "mod", "tidy"
    system "go", "build", *std_go_args(ldflags: "-X github.com/appwrite/sdk-for-cli/internal/app.Version=#{version}")

    generate_completions_from_executable(bin/"appwrite", "completion")
  end

  test do
    output = shell_output("#{bin}/appwrite client --endpoint http://localhost/v1 2>&1", 1)
    assert_match "Error: invalid endpoint", output

    assert_match version.to_s, shell_output("#{bin}/appwrite --version")
  end
end