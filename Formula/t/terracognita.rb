class Terracognita < Formula
  desc "Reads from existing Cloud Providers and generates Terraform code"
  homepage "https://github.com/cycloidio/terracognita"
  url "https://ghproxy.com/https://github.com/cycloidio/terracognita/archive/v0.8.4.tar.gz"
  sha256 "7420694805c3ab666591b9686958eb49e61452065546f0eb315f215c8241da84"
  license "MIT"
  head "https://github.com/cycloidio/terracognita.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bbd00a7bc6811d48d638ac1e8b4b6a9a9845db156627566f50ecf6fd84b3b188"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fca8f74b9f5fa7410e7abe7d6f5388ed960ab552b3da92064c57f44396c49a56"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fca8f74b9f5fa7410e7abe7d6f5388ed960ab552b3da92064c57f44396c49a56"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fca8f74b9f5fa7410e7abe7d6f5388ed960ab552b3da92064c57f44396c49a56"
    sha256 cellar: :any_skip_relocation, sonoma:         "cf950d168859c9c7a3b40a524f2dda3f8d585834a275936fb70c2a20dd969f07"
    sha256 cellar: :any_skip_relocation, ventura:        "f01273cbda69dc4373fd896c787361f4f9b9da0ff70b5901fa96b551305cfbcd"
    sha256 cellar: :any_skip_relocation, monterey:       "f01273cbda69dc4373fd896c787361f4f9b9da0ff70b5901fa96b551305cfbcd"
    sha256 cellar: :any_skip_relocation, big_sur:        "f01273cbda69dc4373fd896c787361f4f9b9da0ff70b5901fa96b551305cfbcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22ca7df6e40ef40b990867a5a81b2e2b883f0867d1be7c8179c178d997e847a1"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cycloidio/terracognita/cmd.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/terracognita version")
    assert_match "Error: one of --module, --hcl  or --tfstate are required",
      shell_output("#{bin}/terracognita aws 2>&1", 1)
    assert_match "aws_instance", shell_output("#{bin}/terracognita aws resources")
  end
end