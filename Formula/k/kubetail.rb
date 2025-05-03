class Kubetail < Formula
  desc "Logging tool for Kubernetes with a real-time web dashboard"
  homepage "https:www.kubetail.com"
  url "https:github.comkubetail-orgkubetailarchiverefstagscliv0.4.4.tar.gz"
  sha256 "31780a04bac9cb7303eb35f7eb6eb3ed1a422df6d1e142ba3d53648671f5a7bf"
  license "Apache-2.0"
  head "https:github.comkubetail-orgkubetail.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a81a44ccb4dfd0279ec4d59d8cac0df9bfad0cbb5aa000db85b3d65c64d92b1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f970fd3239eea852c18e92a0b6ff0997bb0dbb7e03537d10efff88321d12ae66"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5ce4e594cfb3c2cbc7c6ef355bcfc080a663b419e2b67351e212755a02c37dc3"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a64b594885ae01bd61c784dd358b6405dcb43ae4d76ee68cbf65b73cb1a208c"
    sha256 cellar: :any_skip_relocation, ventura:       "cf54812a4723aa746fcc0fd19b3b79b3a2022a7065ed290880a977814de54c17"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74f82739b5874a7ccb9318a7c8c85e0770c78ceff7eba6079495ed68ff28e934"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "917d8fb9e199c66ecaa5a39ed01961850f6abfbfb639af77836f631ed1a56bfc"
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