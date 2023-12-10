class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://ghproxy.com/https://github.com/projectdiscovery/nuclei/archive/refs/tags/v3.1.1.tar.gz"
  sha256 "f25a87dc8416d9740af7affd74400097934f53385d3b5b4c0d4f80f89fa5503c"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4efa1e04fc232c4bdaa97619ecbff86924a34a7e5c2572066f290b4b4d96f631"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0e294831d1d11cf45d205718ffe3743212cdff43d372f344a04359f64e75c17"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf90e92f29fcfe5cd5e3cd3801d8dd6cff3bb3aac16415277f20d1059ff639c9"
    sha256 cellar: :any_skip_relocation, sonoma:         "6419f04d25a85c0bb0cc8c13a1220c59df0b5af52394de0b3ee85ad7314b0ef7"
    sha256 cellar: :any_skip_relocation, ventura:        "67c0a2a65004bc4bc72361ca60369e4e0c7b429cc552e2cd457f762a6c1079e6"
    sha256 cellar: :any_skip_relocation, monterey:       "d73c5484686cbfa82241a1f6d70d1cd7e33d12a929c5b86affc0a3c11b8feeaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4f09c1c9785d05c9393bbd54c3acfa4d8d38b588d64ddd0ed25a43567014232"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/nuclei"
  end

  test do
    output = shell_output("#{bin}/nuclei -scan-all-ips -disable-update-check example.com 2>&1", 1)
    assert_match "No results found", output

    assert_match version.to_s, shell_output("#{bin}/nuclei -version 2>&1")
  end
end