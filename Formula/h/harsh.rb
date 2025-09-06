class Harsh < Formula
  desc "Habit tracking for geeks"
  homepage "https://github.com/wakatara/harsh"
  url "https://ghfast.top/https://github.com/wakatara/harsh/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "fcb3ce1ed338319d473f1c2034ee9be1854d24cff3ae51dc9d287e7c3cff4884"
  license "MIT"
  head "https://github.com/wakatara/harsh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91af5720cf8c85672c4d4c223f988d69dba78306b0a5728f8a121b325df4c1b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91af5720cf8c85672c4d4c223f988d69dba78306b0a5728f8a121b325df4c1b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "91af5720cf8c85672c4d4c223f988d69dba78306b0a5728f8a121b325df4c1b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "03943587049713383bd7ed420dd69f043be2525967fd455442ed152da5779ccc"
    sha256 cellar: :any_skip_relocation, ventura:       "03943587049713383bd7ed420dd69f043be2525967fd455442ed152da5779ccc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd2796e42847ec435199542f66ac0a552f89118cd9b2f5f8c7851e9926e60ee5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "Welcome to harsh!", shell_output("#{bin}/harsh todo")
    assert_match version.to_s, shell_output("#{bin}/harsh --version")
  end
end