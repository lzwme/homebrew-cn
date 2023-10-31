class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https://www.massdriver.cloud/"
  url "https://ghproxy.com/https://github.com/massdriver-cloud/mass/archive/refs/tags/1.5.11.tar.gz"
  sha256 "5de36f78e11d0e5ef54797f1529b27c46e47e6966b092956e70a2486cb4c0dba"
  license "Apache-2.0"
  head "https://github.com/massdriver-cloud/mass.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b9b89d0b2c25b90afbc3a7dad01c0c91fae483bc93c362d35bd68558b5f3e80b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5eace24db59c31e4a3f05693d3bbab687fe9bb96dfdbe839181b01dd89031cbf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf6a5fd6964bcffc3b6773ce413745844a6987ddfa67111601b541f94d524541"
    sha256 cellar: :any_skip_relocation, sonoma:         "64e091fcccfecf9f173819e3221a2d4905082222c0f4d019af4dae7ef0ef9d5e"
    sha256 cellar: :any_skip_relocation, ventura:        "f6000a7991fc03cf78834c541035b173de9d9963cdaaabc0d05330166da3002f"
    sha256 cellar: :any_skip_relocation, monterey:       "1d10443e3653856461d6d7d100b0e3e5cb3a464ff7d12f1cebb1c1be40445f62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a2c48ee766e4d5fe560dc8b1bcc2306a36465056da55833ab8154478bb339f7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/massdriver-cloud/mass/pkg/version.version=#{version}
      -X github.com/massdriver-cloud/mass/pkg/version.gitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"mass")
    generate_completions_from_executable(bin/"mass", "completion")
  end

  test do
    output = shell_output("#{bin}/mass bundle build 2>&1", 1)
    assert_match "Error: open massdriver.yaml: no such file or directory", output

    output = shell_output("#{bin}/mass bundle lint 2>&1", 1)
    assert_match "OrgID: missing required value: MASSDRIVER_ORG_ID", output

    assert_match version.to_s, shell_output("#{bin}/mass version")
  end
end