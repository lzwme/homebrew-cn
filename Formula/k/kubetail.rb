class Kubetail < Formula
  desc "Logging tool for Kubernetes with a real-time web dashboard"
  homepage "https:www.kubetail.com"
  url "https:github.comkubetail-orgkubetailarchiverefstagscliv0.0.8.tar.gz"
  sha256 "d1a5274688379f7e5b5775e44c1465f9c46d07957f096a32a62bd299f7921c63"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{^cliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a46e2e2c3aa7e7557da12014fcf1541f0e4a6e16381173bdbef0973f3c043d16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d23292f3714a95485f12c3fd8442e5e7c86769dfd238071c80603f22d53da90b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "82b131affdd59ef2063e8676aeece3e74130059a5de7a44e679d0c5cc1281db3"
    sha256 cellar: :any_skip_relocation, sonoma:        "abf57d3176003d355d954c0ffb838de00d74da5347058b5e36471092b7de6f88"
    sha256 cellar: :any_skip_relocation, ventura:       "76144d6d1d0b9c93bcd146f729765ac869786b54dd5aa629c9ecf2bfead95945"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea2664e7d8e8cf333df6c6240add44fdccd616c22dce5bf1abc6a6fb6f9ec059"
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