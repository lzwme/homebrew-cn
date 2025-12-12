class Terratag < Formula
  desc "CLI to automate tagging for AWS, Azure & GCP resources in Terraform"
  homepage "https://www.terratag.io/"
  url "https://ghfast.top/https://github.com/env0/terratag/archive/refs/tags/v0.7.5.tar.gz"
  sha256 "9d10d54242150ede67a44d3eda147a448a769e428f92470abe06fac66c78596c"
  license "MPL-2.0"
  head "https://github.com/env0/terratag.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "61c09afa873b801d0e143237921d8594fb7ed4836cdcd28d9c30611aa35212c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61c09afa873b801d0e143237921d8594fb7ed4836cdcd28d9c30611aa35212c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61c09afa873b801d0e143237921d8594fb7ed4836cdcd28d9c30611aa35212c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "76f7b7d8bdd9a05d45d9923014820cd173da25b2e850f1ce6a1767a330541a7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8309d1bc1c1b2476a7ce78be47d207952fad6eb9da3b1c17270e46813f5bb50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f54c2b3fabea49391ac48ae17d9635fe990a89aa03645928224ee4ead40c9535"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/terratag"
  end

  test do
    (testpath/"main.tf").write <<~EOS
      provider "aws" {
        region = "us-east-1"
      }

      resource "aws_instance" "example" {
        ami           = "ami-12345678"
        instance_type = "t2.micro"
      }
    EOS

    output = shell_output("#{bin}/terratag -dir #{testpath} " \
                          "-tags '{\"environment\":\"test\",\"owner\":\"brew\"}' -rename=false 2>&1", 1)

    assert_match "terraform init must run before running terratag", output
  end
end