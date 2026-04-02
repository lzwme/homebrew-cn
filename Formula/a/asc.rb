class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rudrankriyam/App-Store-Connect-CLI/archive/refs/tags/0.49.0.tar.gz"
  sha256 "0c538896d0e60de5e9871c34c74753160548054d929c9e30134eb595a908ed82"
  license "MIT"
  head "https://github.com/rudrankriyam/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "13859d0a8870dc15aa1cb11321396425d1b76b1193e2e05ed2ba0d01ac5320fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69be52c58a22b6f547b7eacb392fd9076b5ac024378233211b8ddfcd28488040"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c4fe90433746eb77010872a1fd1b615e89edccd2d77279bb82871513281181b"
    sha256 cellar: :any_skip_relocation, sonoma:        "18e95f058bb9bf8b30ae4e4fae09138b46d35904a3e6d0e8ac0a0e27ce4a39c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a624902fc60babebdf5ff991f1da99a04b7a6c4cd604afdbcb49f29531ade67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4de14187b22f55690a9e21593327747c77cdb0da27c56b50dae57b9e209dec4d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"asc", "completion", "--shell")
  end

  test do
    system bin/"asc", "init", "--path", testpath/"ASC.md", "--link=false"
    assert_path_exists testpath/"ASC.md"
    assert_match "asc cli reference", (testpath/"ASC.md").read
    assert_match version.to_s, shell_output("#{bin}/asc version")
  end
end