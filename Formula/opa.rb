class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://ghproxy.com/https://github.com/open-policy-agent/opa/archive/v0.50.0.tar.gz"
  sha256 "936d6c9f7cdf4d428bfae7be3f72c20b6b1f1a84355e5c9497920803eb196709"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d10fbecdf1b68b007ed8b2ff91cfbdb73c6a52c4eaaca739cae308ec3df1865"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e51fecbe3f11206991f2e8eed418cd159033bef247734d7464b29a64c361939"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7aa3368fc791e60b9e54f549844d4be4977896518db0953a06088eefeab9b197"
    sha256 cellar: :any_skip_relocation, ventura:        "104a51d86340a3d80159f767f93d840812f0ca0a8f3e8a83701c19e5a36d7ae7"
    sha256 cellar: :any_skip_relocation, monterey:       "fd247fb42e24c8940407cb63a032888816442439b0c97879c54cda7a9df35694"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d4751a4b46932ac98833037d7a13bc1705845b3ab9f6ea276c4b6645f7eb3ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca54cb1831f24e8574442038179d5206731e72ed6b594ee1ccdbfd1f9019f119"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/open-policy-agent/opa/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
    system "./build/gen-man.sh", "man1"
    man.install "man1"

    generate_completions_from_executable(bin/"opa", "completion")
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "+---+---+\n| x | y |\n+---+---+\n| 1 | 2 |\n+---+---+\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end