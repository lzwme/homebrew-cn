class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://ghfast.top/https://github.com/planetscale/cli/archive/refs/tags/v0.260.0.tar.gz"
  sha256 "a252ed1dced02a818c2a0332edc64b0e8af3a1e380b077baf1499ae71391e955"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70cbf0400675bdc532b03dead08c74633d8ddb4982f83a32c8f476f700a32a44"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0f51be0c67596e65dfd3e90b26bd46522a25e4aca27b1ef6c6507e02fdb8005"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a48fde8c1cb70460b1ed4bffcddc9dbaffb4e7b09ab9288747744fc3597c2f47"
    sha256 cellar: :any_skip_relocation, sonoma:        "0cee1824a724ab8f00f1f4fed72193d0880acd7247fd35a6c70f56b6fd89382a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54fce8f26bbe44298593ffcff8678a4ab850eebe61d8fe2d3c20cbbc7598a94e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "166edc17a73b607c83cced297cce48488e9dec8ed2502831e335348a3f875c82"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/pscale"

    generate_completions_from_executable(bin/"pscale", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pscale version")

    assert_match "Error: not authenticated yet", shell_output("#{bin}/pscale org list 2>&1", 2)
  end
end