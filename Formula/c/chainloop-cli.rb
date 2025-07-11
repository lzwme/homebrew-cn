class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.27.0.tar.gz"
  sha256 "4f022b7c00e402abc9e575480bb4ef1f8d04e3b84e489f6d9dada45b8ebbf603"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ebe26fe5b83fb086e53a3976a80e49e5383aa62b7720b88780ca9458496c82b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "459147554bd1268d52f14f863a394e35b330d6bbba8a8dc306198fbabb8b3879"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "328b6202ff8e631ec9e0314a54ef6ea0c54778ebb9ee7e433ee08fbf0f451cff"
    sha256 cellar: :any_skip_relocation, sonoma:        "093772a0c5674f49bc4dd78678d761dd1b9be887ec5de02e3bf2168c44fce5e0"
    sha256 cellar: :any_skip_relocation, ventura:       "f879ce60eb81b5af8116a390f4e8319004d76d3b6ddb3fcd4b8c129aab99fc36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74c6ba64530ab0323548591f182dc15ebcdf3c54ca6add2e7a53cca27af0bd43"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end