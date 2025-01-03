class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https:terramate.iodocscli"
  url "https:github.comterramate-ioterramatearchiverefstagsv0.11.6.tar.gz"
  sha256 "9f1c0699543738fe79d7a8368cb8fe1869c774ee197f172fc1e5057078db76a8"
  license "MPL-2.0"
  head "https:github.comterramate-ioterramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce6c52a69c5f5ea48dd782124986085c327ed2234fd4f25a86da2d0a7d633794"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce6c52a69c5f5ea48dd782124986085c327ed2234fd4f25a86da2d0a7d633794"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ce6c52a69c5f5ea48dd782124986085c327ed2234fd4f25a86da2d0a7d633794"
    sha256 cellar: :any_skip_relocation, sonoma:        "58d62e5a99a100f0522838fff9c345f098982c018c41a875e9c170f5e71a8c46"
    sha256 cellar: :any_skip_relocation, ventura:       "58d62e5a99a100f0522838fff9c345f098982c018c41a875e9c170f5e71a8c46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a00c4ce9ff157812d9f64179f58dd421c09b076e0dd51b7bd47420a10c0f941"
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