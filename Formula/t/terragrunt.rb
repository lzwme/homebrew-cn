class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.55.1.tar.gz"
  sha256 "950b13109eb0bc04a634ef3cc2af65114019dd594c4414a71d9bdc10c65fe1b7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0d3fed7a84cc12853089a45dcb23a6ab01d560269462cb44313bf1d77df56cbc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f19b9aa21635486c08d11cd36d2e5645c8954da0a007f434e2ee70370a8970f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0eb7e731fe23a564e8848ddeddc2b23e2fd8ff30bbcd72671e475f96ed85f559"
    sha256 cellar: :any_skip_relocation, sonoma:         "3133f6426f60054ef058eb246280f9c7dea8a6634589f001e41108944fbb36e6"
    sha256 cellar: :any_skip_relocation, ventura:        "b6ed6555a92db1137ab7384dba0fb7bc448fec5d805f7c1c8192d940074f899c"
    sha256 cellar: :any_skip_relocation, monterey:       "590b1d5b900138dbb2843fb63906a438c4b9c7ed2ca6d7b202901693f20f6403"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eddf993cc63e9e2513e8ef57da2698626f1f94d33df7aa38534d609931aca010"
  end

  depends_on "go" => :build

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.comgruntwork-iogo-commonsversion.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}terragrunt --version")
  end
end