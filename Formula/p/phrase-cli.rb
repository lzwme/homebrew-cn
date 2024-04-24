class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https:phrase.com"
  url "https:github.comphrasephrase-cliarchiverefstags2.25.0.tar.gz"
  sha256 "77e7f80365851df20bd5829a51dc23125eb151aa3eafe9bbb4c9516ae94c737a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fd4933dce916d26e1231adcb889f1b0479341487a8c194f73450a0caeb55c92e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d65c1d3342e68db5119c436e56656d278921420e620b74d6cd334d88fd50e47"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b496d996fef592a4b45774bdf8674b6b7a595ec38ce212a450d160c739b3e8c"
    sha256 cellar: :any_skip_relocation, sonoma:         "d41510dcfd3cd1d274b5e89d7e6d0cba801ea897284566088938728b60eaa23e"
    sha256 cellar: :any_skip_relocation, ventura:        "2fd27640bccc49f68dd46bcda6dab5c05d55e5881ab70b26908cc73f47fae80f"
    sha256 cellar: :any_skip_relocation, monterey:       "911cb772f1fbac07f169d82eb1b2f26d243509c44efb04aaa9e8886d7f8e483f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dec67ee5695b4a2ee1d3b0209aaacf861c8483dd7b4a5aa1825c70dcac4f0725"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comphrasephrase-clicmd.PHRASE_CLIENT_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    bin.install_symlink "phrase-cli" => "phrase"

    generate_completions_from_executable(bin"phrase", "completion", base_name: "phrase", shells: [:bash])
  end

  test do
    assert_match "ERROR: no targets for download specified", shell_output("#{bin}phrase pull 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}phrase version")
  end
end