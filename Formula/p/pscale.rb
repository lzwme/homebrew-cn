class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https:www.planetscale.com"
  url "https:github.complanetscalecliarchiverefstagsv0.218.0.tar.gz"
  sha256 "dca5d5cce7e001c46ea8e39dc8717185d4818861c093d1d4a9c83f1efc41b362"
  license "Apache-2.0"
  head "https:github.complanetscalecli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5589751ad82bf89c09bfa2face8ef12026bc34e8a6f38ee9158f084b9eccc4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2018d4c58acb3fea7e3d700e74a3904906074696362eca8a28c8214cbf6f7ccc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2d3116807a07a1b7074cb0fe97ac34affeec77ebdc099db5929ee6eb2b1b1cae"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e7306f487b6361a8667d2096454a2d961dc44661b6c6221a88337ca034e70d6"
    sha256 cellar: :any_skip_relocation, ventura:       "8be107f8ce574bd1f5ed1aa253fc3921a64cd8d5dc84fa53414d44725a723c7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2e3bf08a91d8704e479736d2ab2f0d6faabc244f6908718fa3106b378096bed"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), ".cmdpscale"

    generate_completions_from_executable(bin"pscale", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}pscale version")

    assert_match "Error: not authenticated yet", shell_output("#{bin}pscale org list 2>&1", 2)
  end
end