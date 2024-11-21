class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https:terramate.iodocscli"
  url "https:github.comterramate-ioterramatearchiverefstagsv0.11.2.tar.gz"
  sha256 "1a59e9f9a1335f4a9bc8e7c8e0d06d73fbca63ce4d2dfa5a48397d9c0862b818"
  license "MPL-2.0"
  head "https:github.comterramate-ioterramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7bb163ea2e8f00cb6eb2b12f8d57aa7dfa3e9d657dfe17b3309cc8772a85341"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7bb163ea2e8f00cb6eb2b12f8d57aa7dfa3e9d657dfe17b3309cc8772a85341"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f7bb163ea2e8f00cb6eb2b12f8d57aa7dfa3e9d657dfe17b3309cc8772a85341"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3c732d8aec318891ae0ab2f6e3a0fc279b7b50403531cc60a686f7ab959d880"
    sha256 cellar: :any_skip_relocation, ventura:       "c3c732d8aec318891ae0ab2f6e3a0fc279b7b50403531cc60a686f7ab959d880"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "345d878e294d4012477815a4869f17d167af25f26f1ada8863c5cdcc45e2f02b"
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