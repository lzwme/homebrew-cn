class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https:terramate.iodocscli"
  url "https:github.comterramate-ioterramatearchiverefstagsv0.11.4.tar.gz"
  sha256 "981a4e4abfa57db184be8a63ac22bfcf65529bfcf00493ad66c11abf1c4c2013"
  license "MPL-2.0"
  head "https:github.comterramate-ioterramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e83710ef9225a88345780460a096a0b5022e65c914ea6cc9bc06993b3784c7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e83710ef9225a88345780460a096a0b5022e65c914ea6cc9bc06993b3784c7b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1e83710ef9225a88345780460a096a0b5022e65c914ea6cc9bc06993b3784c7b"
    sha256 cellar: :any_skip_relocation, sonoma:        "89b5cce5c40db0df13a33d18a40f40db80e6f70612eb1ca918840a22a42b0fc8"
    sha256 cellar: :any_skip_relocation, ventura:       "89b5cce5c40db0df13a33d18a40f40db80e6f70612eb1ca918840a22a42b0fc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25fe112a81aca888647130ad6b7077e1d352539546ebb0f6621d79463d0cb29a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin"terramate", ldflags: "-s -w"), ".cmdterramate"
    system "go", "build", *std_go_args(output: bin"terramate-ls", ldflags: "-s -w"), ".cmdterramate-ls"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}terramate version")
    assert_match version.to_s, shell_output("#{bin}terramate-ls -version")
  end
end