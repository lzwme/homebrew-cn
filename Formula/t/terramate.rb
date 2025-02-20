class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https:terramate.iodocs"
  url "https:github.comterramate-ioterramatearchiverefstagsv0.12.0.tar.gz"
  sha256 "270d4f749f48e28e93b723f77ab80c1316b3967b9e805efc87f88a474f5c7a35"
  license "MPL-2.0"
  head "https:github.comterramate-ioterramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8cba3677c4c56c051f8a94c19dcfe5ad205cded8bda4b76766c60e3161007677"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8cba3677c4c56c051f8a94c19dcfe5ad205cded8bda4b76766c60e3161007677"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8cba3677c4c56c051f8a94c19dcfe5ad205cded8bda4b76766c60e3161007677"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e802ad9e389800bf9055d11baf9ba6988baecff6bec7190e60578642d0dacc9"
    sha256 cellar: :any_skip_relocation, ventura:       "8e802ad9e389800bf9055d11baf9ba6988baecff6bec7190e60578642d0dacc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e7ccc72afe0ff4add43e0cb04b95a1943955d8e9c002be5e79fe4d13e93b57c"
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