class Kubetail < Formula
  desc "Logging tool for Kubernetes with a real-time web dashboard"
  homepage "https:www.kubetail.com"
  url "https:github.comkubetail-orgkubetailarchiverefstagscliv0.1.0.tar.gz"
  sha256 "b0492f53c2525c628fd978febbfc4c25d4627fb21bc6aa935f39f5229d60ab75"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{^cliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b32d2e58c892e3f5a446fb87f2f28f39b366f4e2cccb7815629220598874ba34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29ec559bf81c17ddeb9b7ef09332a6871c210a69341bf6d9c2779170da9c6d69"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "93f73dd766d97cc1c64a6b006bef229c5de3520bef6233e1b559412dce47e036"
    sha256 cellar: :any_skip_relocation, sonoma:        "f73639739c7833e57c2a09c1a7cb57f586d5d7dbae0d91f29196585ca7ec19fb"
    sha256 cellar: :any_skip_relocation, ventura:       "f2cbc1b78dfb2d0df57939bd153f3dbec60ecd3850a12bdcc94ae98f2df719e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07519bc79e16128f656c2ecf6835013cdeb8bdc58822df1a345c9cd2e42eeee0"
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