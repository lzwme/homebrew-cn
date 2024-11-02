class Ctlptl < Formula
  desc "Making local Kubernetes clusters fun and easy to set up"
  homepage "https:github.comtilt-devctlptl"
  url "https:github.comtilt-devctlptlarchiverefstagsv0.8.35.tar.gz"
  sha256 "67906ada26be934b0a2af574e1f6a52e72ae34cf02bef88f1ef9afdd459dc7d8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33a286b814c602b50f8776d6f83528f527026d793e7eac3c76def15831ca8d07"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1c24730304915173a73418a41081221781f88179925bc662d115903377aea1a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "557881046faa2a851aeb3e14df484ca33b48c7c654206d3797e80dd54e4965f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "87ef5dfe6e80471b6b422a64f93454938b37091b128702f13dfa7bab17868952"
    sha256 cellar: :any_skip_relocation, ventura:       "57c24df0bbdec555886923fd065fa7f51bf6e2ca17a782f1adacc2788be59767"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51a619d1511f3970152d9acd607c44624592028ac44fefe0e0171829346808a0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdctlptl"

    generate_completions_from_executable(bin"ctlptl", "completion")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}ctlptl version")
    assert_equal "", shell_output("#{bin}ctlptl get")
    assert_match "not found", shell_output("#{bin}ctlptl delete cluster nonexistent 2>&1", 1)
  end
end