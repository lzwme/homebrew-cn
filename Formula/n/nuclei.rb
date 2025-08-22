class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://docs.projectdiscovery.io/tools/nuclei/overview"
  url "https://ghfast.top/https://github.com/projectdiscovery/nuclei/archive/refs/tags/v3.4.8.tar.gz"
  sha256 "fcf8fe2a2d55de851586872bbfaba8cb362ffceb904bb67e7a2fd0cd5d8554a1"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5970be85d287fdbc09f85f1c0d2002cebd3b8edd545d933e92937bd3b3d8a5ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c35f54795ac048673e775120b10f218047005daf7e1d5c5aebf88bf5056a390"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4be31a877221ea16f218610d8713ba929c4355e10080ac3f2e9b1aa32e098e49"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b736ca750a01892eff31554c28fe01f82149d850d2d3dd322647a32c375f94d"
    sha256 cellar: :any_skip_relocation, ventura:       "54645a1da374fc9428e4d778b93a39c6e980d48b70dd3adb08fa32fdb90324dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee0ee14f04d9fb0700347cbaa1bf993fa08b893417aecccc6674cb94c5700df8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "680eee93b90988c9b2a3a6bda2d354babb0ab299f5221d40b700845e149c8e8d"
  end

  # use "go" when https://github.com/projectdiscovery/nuclei/pull/6348 is released (in 3.4.8 release?):
  depends_on "go@1.24" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/nuclei"
  end

  test do
    output = shell_output("#{bin}/nuclei -scan-all-ips -disable-update-check example.com 2>&1", 1)
    assert_match "No results found", output

    assert_match version.to_s, shell_output("#{bin}/nuclei -version 2>&1")
  end
end