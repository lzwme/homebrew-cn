class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https:github.comsafedepvet"
  url "https:github.comsafedepvetarchiverefstagsv1.8.4.tar.gz"
  sha256 "183df5a02b190e8182fa89d76e60af692378b742009942f451e83c92e756063b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8107f7a025094c29839d890dfe141d24d30baadc94ab7f1c5968db3546bdcf02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c97211b4408fecc5c3630e89825cbca92e0aa79e641a3a2377aa73e6c6bd2d34"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "52dc2e00606b95bc31b6982e36bafbca3796f87a6f78f0073c1aac3f56c23faf"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1bac7b63c76dfb859be5dc929c46600a256de5fa001775df64755cec3763f4a"
    sha256 cellar: :any_skip_relocation, ventura:       "4e028dedfb731e3928904ed4d89f24ce81b95ae36ea7679bfa914f80be1c7474"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6265d746d8dd309b21fdbfdee7c546fe5392cebee029f407a4ee38babaa9321"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.commit=#{tap.user}
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"vet", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}vet version 2>&1", 1)

    output = shell_output("#{bin}vet scan parsers 2>&1")
    assert_match "Available Lockfile Parsers", output
  end
end