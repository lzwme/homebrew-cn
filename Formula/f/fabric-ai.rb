class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.267.tar.gz"
  sha256 "55863f0fb8b5dbec91cd46ba57e8f115292e7171d22c08b676f605ee51c8ee30"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a42555e64a68fff676b10262c73fa07020a506e08b8f956de290acb1185c954"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a42555e64a68fff676b10262c73fa07020a506e08b8f956de290acb1185c954"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6a42555e64a68fff676b10262c73fa07020a506e08b8f956de290acb1185c954"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d07c38bfa1b84d69647c27b7bcb3af2474633a649cdc5fd58432334300b1be8"
    sha256 cellar: :any_skip_relocation, ventura:       "8d07c38bfa1b84d69647c27b7bcb3af2474633a649cdc5fd58432334300b1be8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9360c4a46c377bb97d3843b9c686a1a1adcdbb5aba9e8ee1818bf691c643eeb7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/fabric"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fabric-ai --version")

    (testpath/".config/fabric/.env").write("t\n")
    output = pipe_output("#{bin}/fabric-ai --dry-run 2>&1", "", 1)
    assert_match "error loading .env file: unexpected character", output
  end
end