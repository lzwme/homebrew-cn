class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://ghproxy.com/https://github.com/open-policy-agent/opa/archive/refs/tags/v0.58.0.tar.gz"
  sha256 "24915403eff7a3bcaf55a94b28a2a77a8f194546071a128616e8afc42a970e78"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bd9a9dd89816b30aad4d9357e74ae9b6a16e8449edb4dbcd85145349b16dea41"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea4da471260bea66bb8239de96780e49d7319db3d80eba660bef7a3baa77fd54"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3cece87591dc7290d51429482fc32a1191da7aebd542a18a54523b6c65a6a414"
    sha256 cellar: :any_skip_relocation, sonoma:         "7a288e19b70d66f277876555c5863b5c4b7f8414f3f7250de8d4c90399ba00f7"
    sha256 cellar: :any_skip_relocation, ventura:        "614379919902de2f21e434e86573bad4021ac048863dc03c0657b9e31613edc4"
    sha256 cellar: :any_skip_relocation, monterey:       "bbf1ac7703a91dde8381b7d7ea371fc7d722787638189c5a96d44bbe36cecd97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4cea6a76586c53d6045970bc478d546a288e094ccf6451a574660d6907f702b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/open-policy-agent/opa/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
    system "./build/gen-man.sh", "man1"
    man.install "man1"

    generate_completions_from_executable(bin/"opa", "completion")
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "+---+---+\n| x | y |\n+---+---+\n| 1 | 2 |\n+---+---+\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end