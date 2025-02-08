class Kubetail < Formula
  desc "Logging tool for Kubernetes with a real-time web dashboard"
  homepage "https:www.kubetail.com"
  url "https:github.comkubetail-orgkubetailarchiverefstagscliv0.1.2.tar.gz"
  sha256 "cd9c421eb43bb47d0510cbe2950d7cc6fd8783ba11f0a994d942a880f2ff3d40"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{^cliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9b7a50076da0aa9c62a57dfba0104f6945c8d50da0621e28a818f7841492344"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63a8670fbffbf63b7b153f58433916b6aa915d292337adbdf4e6b0cd702c0711"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aad2eed728b572b381c507f75558ebc0f78d6f6ab9e7fb74ca4bb27684a16417"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a27e51703a706e70c177b1f98278ef06904518d641a145158683f2f280d2183"
    sha256 cellar: :any_skip_relocation, ventura:       "dbed94e9eb3a0f0ea8207a3778778689559710344fc96450f04fd86f651065ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7533d06466d66ca85174bdd6bac2637a268be78539e25c4bf07922d946970936"
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