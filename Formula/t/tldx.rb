class Tldx < Formula
  desc "Domain Availability Research Tool"
  homepage "https:brandonyoung.devblogintroducing-tldx"
  url "https:github.combrandonyoungdevtldxarchiverefstagsv1.2.4.tar.gz"
  sha256 "5bc6836e033ae63187b17e523e808cfd8bb6525715163fdc158bf85f36a2b834"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c612ef36e0440e412999867521b005966e45c8cd57b42e03cdec3817cb7efe7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c612ef36e0440e412999867521b005966e45c8cd57b42e03cdec3817cb7efe7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1c612ef36e0440e412999867521b005966e45c8cd57b42e03cdec3817cb7efe7"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f82dc3db2fc83afd4056689c6c641e736f039a47cdfd2fbae71dddfb0752833"
    sha256 cellar: :any_skip_relocation, ventura:       "3f82dc3db2fc83afd4056689c6c641e736f039a47cdfd2fbae71dddfb0752833"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc5a475ee20d17587e1be1de815f5e34dc8fd4460c78f8979ebddd2b839f5db5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.combrandonyoungdevtldxcmd.Version=#{version}")
  end

  test do
    assert_match "brew.sh is not available", shell_output("#{bin}tldx brew --tlds sh")

    assert_match version.to_s, shell_output("#{bin}tldx --version")
  end
end