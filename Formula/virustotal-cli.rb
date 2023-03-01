class VirustotalCli < Formula
  desc "Command-line interface for VirusTotal"
  homepage "https://github.com/VirusTotal/vt-cli"
  url "https://ghproxy.com/https://github.com/VirusTotal/vt-cli/archive/0.11.1.tar.gz"
  sha256 "76e546a612a1eee0d0522be8dd8cd9d9c4ae42645417335bd05038d835befbd1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d1f742b449fb60a15fbdfac466d785ac4c1ed31fb28b456b0d214c8ea765ef11"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1f742b449fb60a15fbdfac466d785ac4c1ed31fb28b456b0d214c8ea765ef11"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d1f742b449fb60a15fbdfac466d785ac4c1ed31fb28b456b0d214c8ea765ef11"
    sha256 cellar: :any_skip_relocation, ventura:        "9b5920d97a5b8ef4a0df7c02f46add85084becffc8c1dd466b8dcb40f90dfcd5"
    sha256 cellar: :any_skip_relocation, monterey:       "9b5920d97a5b8ef4a0df7c02f46add85084becffc8c1dd466b8dcb40f90dfcd5"
    sha256 cellar: :any_skip_relocation, big_sur:        "9b5920d97a5b8ef4a0df7c02f46add85084becffc8c1dd466b8dcb40f90dfcd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1b0a3cb29e4db006518a120bf4bdfa4f972d192c74b0c238b3c15fafc860cfb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"vt", ldflags: "-X cmd.Version=#{version}"), "./vt/main.go"

    generate_completions_from_executable(bin/"vt", "completion", base_name: "vt")
  end

  test do
    output = shell_output("#{bin}/vt url #{homepage} 2>&1", 1)
    assert_match "Error: An API key is needed", output
  end
end