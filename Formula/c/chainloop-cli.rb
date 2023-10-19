class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghproxy.com/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.21.1.tar.gz"
  sha256 "b503f982deb024de1a2f9c695e69bebfb808ab69708a6a46fb86a18000c3dd52"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "822f69432ac583734ac132efff925b60ff43e81ebcf09d2dd886907754df4663"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "352eb9b34e6e91d32f8835cacf91f5c7a498aad5946dda4dd1944c3b0fd62bd1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68770bc96c30e05d8577f300c3d033fb9a0131aff26027b028f8f06f315622e8"
    sha256 cellar: :any_skip_relocation, sonoma:         "181c9d2c217982594f117301cedcddce063b4607a753b0083db0d3095a2d12b9"
    sha256 cellar: :any_skip_relocation, ventura:        "d94b753386acae8dce4a8154903098b9e1c722e45fe79392989b831d3a254bb5"
    sha256 cellar: :any_skip_relocation, monterey:       "aa3601ae2bcd08c8cd4c99717016fe57fd4f03e84273982590c0dbf5cdd0f0ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c839a998cf00a8dc5eb95291a3915976b41f953393cf150da733e8ba04145a53"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(output: bin/"chainloop", ldflags: ldflags), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", "completion", base_name: "chainloop")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end