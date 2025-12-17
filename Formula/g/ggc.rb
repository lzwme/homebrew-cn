class Ggc < Formula
  desc "Modern Git CLI"
  homepage "https://github.com/bmf-san/ggc"
  url "https://ghfast.top/https://github.com/bmf-san/ggc/archive/refs/tags/v7.0.5.tar.gz"
  sha256 "12c1c415178bb9313c424740dc61739920ba238d0b25f54b9ef984b775ee0b81"
  license "MIT"
  head "https://github.com/bmf-san/ggc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "51912c0733e5c6d5cfbd697dd0b54f0182fbf0c0865cd49ba0dbed474e2704bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51912c0733e5c6d5cfbd697dd0b54f0182fbf0c0865cd49ba0dbed474e2704bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51912c0733e5c6d5cfbd697dd0b54f0182fbf0c0865cd49ba0dbed474e2704bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "c07b7173960a1a6d2176ec151e97e528e4c4edca9525168a98d664a62e510eb3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5ee4718bbfd7ecdbccfd431a8b7c1e657242ac3fd4c5338a4f8c751eefa1e98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5425473c056c108997c749022381c596e4489992f132816141ad3fec34dc9ab"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ggc version")

    # `vim` not found in `PATH`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_equal "main", shell_output("#{bin}/ggc config get default.branch").chomp
  end
end