class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://ghfast.top/https://github.com/planetscale/cli/archive/refs/tags/v0.290.0.tar.gz"
  sha256 "b08f9d18878fa4435b33cc8d5091b2d1bbd75512a0b443a09b7f5d2c5a97b72b"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f6cb02077e50d3a5583e86524194dbfd4297604fc8642dd8f63dc7d0c861bb67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e41ca8f086992306afc84c8e6663105f8900f475f4fb9e8ce769a80c884169e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d59cc8a2c01f406271125aa8b3736781436ca307b0a2534ad1f765c7d742e178"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ad424f85333896c7d51d4395d5128f2a6dea3ef6c92ab8929d66229170a8367"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19e29cfd07ca441c1689a8ea518490f73fdaa2b48aa79b4a5eebc90df94d8cf9"
    sha256 cellar: :any,                 x86_64_linux:  "258b6e3dd3685a2234c427e5cf9479b1c652a560c66c94408b36c291b23f62d4"
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