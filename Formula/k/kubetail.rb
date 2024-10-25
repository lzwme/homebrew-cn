class Kubetail < Formula
  desc "Logging tool for Kubernetes with a real-time web dashboard"
  homepage "https:www.kubetail.com"
  url "https:github.comkubetail-orgkubetailarchiverefstagscliv0.0.4.tar.gz"
  sha256 "926784290f5aaced8842d295fe5de4b35a7cb0c9ce7f562119b5192457d0e4ca"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{^cliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eda2e02d780c851a17ddec7e49ae605971bccea2606c2ec679d755ac46e20561"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da9f485455943d8712637bc708b083cefd2900189129649466748e998db79f5e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f76da40d65fc566c760e3a08334414d84036ff649f9dafe97e009ad3df896eae"
    sha256 cellar: :any_skip_relocation, sonoma:        "21ad57c72490bcba60f4a519772a32422b74d34cd4fb64ebd24a5170c7543422"
    sha256 cellar: :any_skip_relocation, ventura:       "8977a08462fb23ec6a0f8c255b86b7678e86529899169fcb1c9ad03c3e7cc071"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fd55e5edbf7f6df914fd776d1e15bea441f46e44ed160cb19979197596a5eb7"
  end

  depends_on "go" => :build
  depends_on "make" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "make", "build"
    bin.install "binkubetail"
    generate_completions_from_executable(bin"kubetail", "completion")
  end

  test do
    command_output = shell_output("#{bin}kubetail serve --test")
    assert_match "ok", command_output
  end
end