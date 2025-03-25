class Xk6 < Formula
  desc "Build k6 with extensions"
  homepage "https:k6.io"
  url "https:github.comgrafanaxk6archiverefstagsv0.15.0.tar.gz"
  sha256 "d3da50e3491b889bc8f86718bd13d7cc658c5414a94db8d1d05cc6fefd94a8df"
  license "Apache-2.0"
  head "https:github.comgrafanaxk6.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3aeeaed3b94381e9ccb89229cdd4359ae797e7397fde5aaaa80382ebae652560"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3aeeaed3b94381e9ccb89229cdd4359ae797e7397fde5aaaa80382ebae652560"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3aeeaed3b94381e9ccb89229cdd4359ae797e7397fde5aaaa80382ebae652560"
    sha256 cellar: :any_skip_relocation, sonoma:        "d94a4dbaa4a19285d85caaa1634822172073cebfb1cb158f0b864d0c5bcad1f3"
    sha256 cellar: :any_skip_relocation, ventura:       "d94a4dbaa4a19285d85caaa1634822172073cebfb1cb158f0b864d0c5bcad1f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0da3e3a7346169ec244452b7286457e9354c2e6d324f29de3f068d067943e1c1"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdxk6"
  end

  test do
    str_build = shell_output("#{bin}xk6 build")
    assert_match "xk6 has now produced a new k6 binary", str_build
  end
end