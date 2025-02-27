class Kubetail < Formula
  desc "Logging tool for Kubernetes with a real-time web dashboard"
  homepage "https:www.kubetail.com"
  url "https:github.comkubetail-orgkubetailarchiverefstagscliv0.1.4.tar.gz"
  sha256 "ac6c86d7df3f938c12f5a3f6738a2d0140f888fe8e58771a134cfa5067ba9c3a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{^cliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa179ec335ca57ac4c8edeefa65bfa9c466c0948743dc59747369d80185cbf49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9af1be7628f657cd3ec41d6a03b088e267101d98c72835c4f47b92771aff7a2c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8d707621255511eafbd04db30e842eeed5814626f44b03302474652a96ffaef8"
    sha256 cellar: :any_skip_relocation, sonoma:        "0372548e847e6444f971fb14ad7c0786711165a82f6e49d6e68784c20452e63b"
    sha256 cellar: :any_skip_relocation, ventura:       "2f09d3b1dcb6bcc6290f4aed4275ca7d69be440bfef2a47ae82f2abb0966dfdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d783bd6d94fa0013d88fa5fc8c2319446f7c41ec596712714f129e5a73b1675"
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