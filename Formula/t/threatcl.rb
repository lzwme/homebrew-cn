class Threatcl < Formula
  desc "Documenting your Threat Models with HCL"
  homepage "https://github.com/threatcl/threatcl"
  url "https://ghfast.top/https://github.com/threatcl/threatcl/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "407434c1e61f80a96d32260e9a7aa0d682057da70b1625fb4f4901878a339ec7"
  license "MIT"
  head "https://github.com/threatcl/threatcl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7e0c0c8b9689768322ac47c6a0388866253813187204136cf8a205dab97e657"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "707ba474bfb44783673d4a0197f863a8c6b8c7053dc534c5e091b1fc098fa9aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ac075aab2e8d3590945e3493e34e71f83caecbeba2a536e235e309b4119f303"
    sha256 cellar: :any_skip_relocation, sonoma:        "696abf6e2f11a22113f80cfdaecc740ce8496af5a3c1d6c111121e559c2890a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "782fd7d491744b6d36374df4530a614b343048b7bbafa547b9f94ed9f87cefd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "452ce135afb5702c86c7464dcc5fe232669cf24d0eb339788edcde314c5a7a92"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"

    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/threatcl"

    pkgshare.install "examples"
  end

  test do
    cp_r pkgshare/"examples", testpath
    system bin/"threatcl", "list", "examples"

    output = shell_output("#{bin}/threatcl validate #{testpath}/examples")
    assert_match "[threatmodel: Modelly model]", output

    assert_match version.to_s, shell_output("#{bin}/threatcl --version 2>&1")
  end
end