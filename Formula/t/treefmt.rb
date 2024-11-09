class Treefmt < Formula
  desc "One CLI to format the code tree"
  homepage "https:github.comnumtidetreefmt"
  url "https:github.comnumtidetreefmtarchiverefstagsv2.1.0.tar.gz"
  sha256 "1a4d1727c7e2e792993654a54ca4144a2b0a6ac71c3d0812c5256ff14766aa86"
  license "MIT"
  head "https:github.comnumtidetreefmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3a33046c58bfc3a23cc412097af985bb69b2651d88ad803b004710030eaa991"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3a33046c58bfc3a23cc412097af985bb69b2651d88ad803b004710030eaa991"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f3a33046c58bfc3a23cc412097af985bb69b2651d88ad803b004710030eaa991"
    sha256 cellar: :any_skip_relocation, sonoma:        "3640245943f477ba6ce2c3494a58779c6857e2bbabb3aa235a0362d364094401"
    sha256 cellar: :any_skip_relocation, ventura:       "3640245943f477ba6ce2c3494a58779c6857e2bbabb3aa235a0362d364094401"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5973e192989d0d8a2240d4ac2f4ed9765cda7ec0ff96af1cf08ee706057e653"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comnumtidetreefmtbuild.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}treefmt 2>&1", 1)
    assert_match "failed to find treefmt config file: could not find [treefmt.toml .treefmt.toml]", output
    assert_match version.to_s, shell_output("#{bin}treefmt --version")
  end
end