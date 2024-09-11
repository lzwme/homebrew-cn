class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https:terramate.iodocscli"
  url "https:github.comterramate-ioterramatearchiverefstagsv0.10.3.tar.gz"
  sha256 "9ab292bc71930587bcbca990d2dbba11f82aa57531f03e38dd6544c8fc1c469c"
  license "MPL-2.0"
  head "https:github.comterramate-ioterramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d15e5c820e4ede975d1a90fc3329618d78a6d2f4eb8c10ad69efd58b436d1d00"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d15e5c820e4ede975d1a90fc3329618d78a6d2f4eb8c10ad69efd58b436d1d00"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d15e5c820e4ede975d1a90fc3329618d78a6d2f4eb8c10ad69efd58b436d1d00"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d15e5c820e4ede975d1a90fc3329618d78a6d2f4eb8c10ad69efd58b436d1d00"
    sha256 cellar: :any_skip_relocation, sonoma:         "7714fa27670e54ca677051e0a1dab2431c73d35a955afd208f3938bf3387bff2"
    sha256 cellar: :any_skip_relocation, ventura:        "7714fa27670e54ca677051e0a1dab2431c73d35a955afd208f3938bf3387bff2"
    sha256 cellar: :any_skip_relocation, monterey:       "7714fa27670e54ca677051e0a1dab2431c73d35a955afd208f3938bf3387bff2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cd2f3d4421509e765e8298b49084521079886425048df15509e21d43b83e660"
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