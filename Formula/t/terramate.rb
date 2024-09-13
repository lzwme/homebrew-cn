class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https:terramate.iodocscli"
  url "https:github.comterramate-ioterramatearchiverefstagsv0.10.4.tar.gz"
  sha256 "148f09174a99c41621d1feff6fde307eb96b202eb6654b4bbe73c47edf305fbd"
  license "MPL-2.0"
  head "https:github.comterramate-ioterramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "2076702061bfa2e66299ee60aa2e80f3ce70d8832103fbf000c0a07cad56a515"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2076702061bfa2e66299ee60aa2e80f3ce70d8832103fbf000c0a07cad56a515"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2076702061bfa2e66299ee60aa2e80f3ce70d8832103fbf000c0a07cad56a515"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2076702061bfa2e66299ee60aa2e80f3ce70d8832103fbf000c0a07cad56a515"
    sha256 cellar: :any_skip_relocation, sonoma:         "2a985b72052c690a0ea0b2ccc5f06aba2c5ea44df291ebf15ccfd9c1fdaa29fe"
    sha256 cellar: :any_skip_relocation, ventura:        "2a985b72052c690a0ea0b2ccc5f06aba2c5ea44df291ebf15ccfd9c1fdaa29fe"
    sha256 cellar: :any_skip_relocation, monterey:       "2a985b72052c690a0ea0b2ccc5f06aba2c5ea44df291ebf15ccfd9c1fdaa29fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ddca239a103a3c329226d8c87940f75739ee20b12c8d2efa37b73578ac9cb9de"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin"terramate", ldflags: "-s -w"), ".cmdterramate"
    system "go", "build", *std_go_args(output: bin"terramate-ls", ldflags: "-s -w"), ".cmdterramate-ls"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}terramate version")
    assert_match version.to_s, shell_output("#{bin}terramate-ls -version")
  end
end