class Forcecli < Formula
  desc "Command-line interface to Force.com"
  homepage "https://force-cli.herokuapp.com/"
  url "https://ghfast.top/https://github.com/ForceCLI/force/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "850248f1e0d8b3b7ddc351a4f28417b3b3a0c50cca6d43fcf7000648b2bece74"
  license "MIT"
  head "https://github.com/ForceCLI/force.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1abc2ec80ac2cb0c7b08109bc2e603cfb2abfd9e8fcebdbccccdb1d6e2894f59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1abc2ec80ac2cb0c7b08109bc2e603cfb2abfd9e8fcebdbccccdb1d6e2894f59"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1abc2ec80ac2cb0c7b08109bc2e603cfb2abfd9e8fcebdbccccdb1d6e2894f59"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca0e442591b5f45a88ed6b2b24ea8166890a297c5286dcab1e1ab2ca5f454f2f"
    sha256 cellar: :any_skip_relocation, ventura:       "ca0e442591b5f45a88ed6b2b24ea8166890a297c5286dcab1e1ab2ca5f454f2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "224b1816e6f584e6f0dd061d94cc46b7ef245cc9d4e9f5157fa6ba8a95687661"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"force")

    generate_completions_from_executable(bin/"force", "completion")
  end

  test do
    assert_match "ERROR: Please login before running this command.",
                 shell_output("#{bin}/force active 2>&1", 1)
  end
end