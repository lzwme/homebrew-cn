class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https:mindersec.github.io"
  url "https:github.commindersecminderarchiverefstagsv0.0.85.tar.gz"
  sha256 "ac27d3f733f53d672b01df6162066c004d08714c324a91230a4cdd651048405a"
  license "Apache-2.0"
  head "https:github.commindersecminder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7728a8a171c97cdea93ec13a475eac59e81a52c3fa3d99deb7ac1bca42e2640"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7728a8a171c97cdea93ec13a475eac59e81a52c3fa3d99deb7ac1bca42e2640"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d7728a8a171c97cdea93ec13a475eac59e81a52c3fa3d99deb7ac1bca42e2640"
    sha256 cellar: :any_skip_relocation, sonoma:        "90751149589f093e3a7eb1068c330f6563f85e9d29a3b0a72bd5c01d9ec55f77"
    sha256 cellar: :any_skip_relocation, ventura:       "764fc5744eeba3e4e46687b16e54db0b376e53452027c331524f8c3e82f8e8ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec2be954cf9d184c30575e8889bc921b138c3b075de54998322ae8348614b19e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.commindersecminderinternalconstants.CLIVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdcli"

    generate_completions_from_executable(bin"minder", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}minder version")

    output = shell_output("#{bin}minder artifact list -p github 2>&1", 16)
    assert_match "No config file present, using default values", output
  end
end