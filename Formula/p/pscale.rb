class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://ghfast.top/https://github.com/planetscale/cli/archive/refs/tags/v0.304.0.tar.gz"
  sha256 "1e3a28d5ef399a05852851a4172fc875e1456e8500842e50cdf1dc30e2c19e9a"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "01ad920e130b5dfe992cfbe3a7c91eb3b7ca5e21c02fef02ec6b86397912d0df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52edb4e58c352235479cb415e20aa0b05ff47c920561f4f713f8c7a95737b877"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22821997ede3ef9e4c4879782e56025cfb7cd7f6946c8ac1e9c62c23d0597ee4"
    sha256 cellar: :any_skip_relocation, sonoma:        "0be2d41e0ff9b85bbc671fe6ed72e7b966ba353dd1ca963fcc36ee4cee5da32a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61c31bf498f812ebd1934e8b6a40586c46f01ba133393c1ee524f3ecd5ca14cb"
    sha256 cellar: :any,                 x86_64_linux:  "f04e2190b1784d71068f15de9c4a4ee3b1fdd8b039bb8339b1bab585ea1a10ae"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/pscale"

    generate_completions_from_executable(bin/"pscale", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pscale version")

    assert_match "Error: not authenticated yet", shell_output("#{bin}/pscale org list 2>&1", 2)
  end
end