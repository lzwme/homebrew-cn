class Gau < Formula
  desc "Open Threat Exchange, Wayback Machine, and Common Crawl URL fetcher"
  homepage "https:github.comlcgau"
  url "https:github.comlcgauarchiverefstagsv2.2.4.tar.gz"
  sha256 "537abafca9065a7ed5d93aa7722d85da0815abf6b08c2d1494483171558ce3f7"
  license "MIT"
  head "https:github.comlcgau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bcebe9943094a46ec7b7166718717efd633986c99228a269c0c50f38fcc74037"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bcebe9943094a46ec7b7166718717efd633986c99228a269c0c50f38fcc74037"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bcebe9943094a46ec7b7166718717efd633986c99228a269c0c50f38fcc74037"
    sha256 cellar: :any_skip_relocation, sonoma:        "10d23c1e073ad46bc37e270a2f8c9bab12fb8a620114b86cc3192556922f3265"
    sha256 cellar: :any_skip_relocation, ventura:       "10d23c1e073ad46bc37e270a2f8c9bab12fb8a620114b86cc3192556922f3265"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e7a5ed750fc77cf005a7cd657dcffab2f58d5b75f16ccfefff2fd59f5a881d9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdgau"
  end

  test do
    output = shell_output("#{bin}gau --providers urlscan brew.sh")
    assert_match %r{https?:brew\.sh(|:)?.*}, output

    assert_match version.to_s, shell_output("#{bin}gau --version")
  end
end