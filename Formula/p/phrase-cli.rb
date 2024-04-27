class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https:phrase.com"
  url "https:github.comphrasephrase-cliarchiverefstags2.26.0.tar.gz"
  sha256 "4cb373851d94fece3ba98cf647f73bd7a0fa48acb50b4d9004217fae859a6937"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "be1317664cb5b8894ffbd4228196f858e3f451707d67f95c85b86c02dba1a28b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8825dfc8dda46f01a61d221add0800ff71685bc5c687a5975b4cab1d3dbc24b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df01979d3b0285d232dbfbbf7b7bc56497abc9066c738aa67fdedd1453dd729a"
    sha256 cellar: :any_skip_relocation, sonoma:         "457849a7b8609bbe00d76da6ded95bbc559110b23d28a7cb65d1dc3c6acdef78"
    sha256 cellar: :any_skip_relocation, ventura:        "645f5a8cb51b1a7434fb3adb46dedd68b1b4c05e4eae4653f3ff1bf29695ab1a"
    sha256 cellar: :any_skip_relocation, monterey:       "f32d029c3f7edae9559cbf3bed51902b493d456ba7d19fc2af6e1729a4806989"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d7ce6350e65c84188013e40bf94a2a64d928a2cb6a23f6921e365b84d3b6a42"
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