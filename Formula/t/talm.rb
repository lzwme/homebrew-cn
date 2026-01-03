class Talm < Formula
  desc "Manage Talos Linux configurations the GitOps way"
  homepage "https://github.com/cozystack/talm"
  url "https://ghfast.top/https://github.com/cozystack/talm/archive/refs/tags/v0.19.5.tar.gz"
  sha256 "68a1cc7edc2f75f67331c320341c07b767e48f0c248f8da4641bdecbb6941508"
  license "Apache-2.0"
  head "https://github.com/cozystack/talm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d307c1bd33559eb1af6ed7efa1592e83016cfa5067814dbdffb01d7c4cc2f181"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42905b420b8b224b39513d9ea4bee19f1d51ca0061b0e429f779d4538bab3202"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87e10a950d15cdaf5c580052eb414e42b2e71a46a7393c95683b48922058e245"
    sha256 cellar: :any_skip_relocation, sonoma:        "cae9262a63b2757fa4f30db8dc186a873f92a68edde790059b606f708fa327f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3c82c56258d334bc0a450d238c022b9b950b83a896cb56c98be65fb72069f37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7413bccb7b961f40817cca17de82b50e2c4ffdc80e89f984f546b4fa55547da9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
  end

  test do
    assert_match "talm version #{version}", shell_output("#{bin}/talm --version")
    system bin/"talm", "init", "--name", "brew", "--preset", "generic"
    assert_path_exists testpath/"Chart.yaml"
  end
end