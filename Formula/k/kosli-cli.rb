class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https:docs.kosli.comclient_reference"
  url "https:github.comkosli-devcliarchiverefstagsv2.7.5.tar.gz"
  sha256 "05436fee011b22c7a1c04c20e79e0a443f041ec671c9168d35083d46fe9aa2c3"
  license "MIT"
  head "https:github.comkosli-devcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0f7ebf0de2f66a89203422091b2fd55ad167e1989c884a3bba60445a23d96f62"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "14b848abc79ed97ded6b78603b029f6ebddb85816942ba92447b794b40c84584"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5efb54f9f3ad440a158ebeb225ead22e950a68e07cf8def7c0776ad2db723fa"
    sha256 cellar: :any_skip_relocation, sonoma:         "25b361ddac329e861268b2eeefa4fde6bff8e62732fd93c0867afa55aa2e39f2"
    sha256 cellar: :any_skip_relocation, ventura:        "fcab8621cc21a6f4c68c8be1844ba690bad031d692c7a2281449f6fb32da42ca"
    sha256 cellar: :any_skip_relocation, monterey:       "2871c6c3f10100c4671f098f4b08d126bac765f8e18e8526c5b9bd9e3531409d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e571a164aba91060ca87bcf618ec2cdee681ed2b4b038764cb1b6d98510e2157"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comkosli-devcliinternalversion.version=#{version}
      -X github.comkosli-devcliinternalversion.gitCommit=#{tap.user}
      -X github.comkosli-devcliinternalversion.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin"kosli", ldflags: ldflags), ".cmdkosli"

    generate_completions_from_executable(bin"kosli", "completion", base_name: "kosli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}kosli version")

    assert_match "OK", shell_output("#{bin}kosli status")
  end
end