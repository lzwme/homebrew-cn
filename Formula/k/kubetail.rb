class Kubetail < Formula
  desc "Logging tool for Kubernetes with a real-time web dashboard"
  homepage "https:www.kubetail.com"
  url "https:github.comkubetail-orgkubetailarchiverefstagscliv0.2.2.tar.gz"
  sha256 "c31e3eb0e4ad67c1e490c071bdaadfec6c7927e235fa6c8b420d226232a1c887"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{^cliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e4fc544d512471725bd8cc4e297c3dedc18940b00c660573714bf993f14d869"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e3cfb4a215988f37f31d0d1d118c909dc4698186012b48d781f460da0820e5a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "46c88f0df76c5e9978ef966f6416b15db6da1e6e1c10e1b6846b9a2110df7edb"
    sha256 cellar: :any_skip_relocation, sonoma:        "c50f2267a656115618b6e4ce819900937b592d88e0af8528e9d276039d874c36"
    sha256 cellar: :any_skip_relocation, ventura:       "971424cac9a03e91f5535e0512e6c29ae838b89dbebcebb58ee888d3b5a4e520"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13bdc515c1649e036bb7390025acb9563960a67681059e59a493b54f8c59533d"
  end

  depends_on "go" => :build
  depends_on "make" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "binkubetail"
    generate_completions_from_executable(bin"kubetail", "completion")
  end

  test do
    command_output = shell_output("#{bin}kubetail serve --test")
    assert_match "ok", command_output

    assert_match version.to_s, shell_output("#{bin}kubetail --version")
  end
end