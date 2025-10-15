class Tbls < Formula
  desc "CI-Friendly tool to document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://ghfast.top/https://github.com/k1LoW/tbls/archive/refs/tags/v1.89.1.tar.gz"
  sha256 "a2ee101712b65e875dc5fa5c63fd12476df89656c7c7c158d1aebccf33f156e4"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f35e335b970b5d807318ac0095b74b0e1fc3373cae7ea9074ee1c4faa025d963"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98e44ea9a74693a3eb63e4904e78ea7773eefeed972aee9013f5f215c031e662"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4865089b192e7aa365554707444b7641aa81f1262eec74aabf58aff25f990faf"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e2ed66df77d38a16daf2e8a7d55bfeb4fe90a45ed3738b78b06a82189c19dec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4689219e354bc344e5231946d9438d9afa42b7b2e090f556c068d37a950d8e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0be306e00ea199e0f1a59a7578467be6eeac4c9cfe2cd0eb1f105bb842432ca1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/k1LoW/tbls.version=#{version}
      -X github.com/k1LoW/tbls.date=#{time.iso8601}
      -X github.com/k1LoW/tbls/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"tbls", "completion")
  end

  test do
    assert_match "unsupported driver", shell_output("#{bin}/tbls doc", 1)
    assert_match version.to_s, shell_output("#{bin}/tbls version")
  end
end