class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://ghproxy.com/https://github.com/phrase/phrase-cli/archive/refs/tags/2.14.0.tar.gz"
  sha256 "0674ea0f188f7e65983beb782c947fd6719b9300dc4fa43ddef6186d7000bf54"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0a8ee00b76e100af921d35782e2da0821a410cd70a988fd13804dc6de176d992"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6dfe8cbbeebfb213da439885a2bb75c30c85e99f7d4ebb0dce248c2fb4c6143"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe5684545990548d68e34647752022041ffa94c52dd58a0a4aa977ce4c09c650"
    sha256 cellar: :any_skip_relocation, sonoma:         "0914549ef8a7643b92ce661d7ce0fc29ab5e22dae490d108ab06b825912c80e1"
    sha256 cellar: :any_skip_relocation, ventura:        "8e87a2913a7fbb07f4699c300b3935f914b5b28d9c1d84ef48f515c07005aa52"
    sha256 cellar: :any_skip_relocation, monterey:       "2da79131ff7989393caf7cac1da383f6ea2223b550a98074932ca2e52aa57bbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2840f475ec4eb8a9e2884ee2522314bce6a71b4a2b73ed7d789d9a8d24c45602"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/phrase/phrase-cli/cmd.PHRASE_CLIENT_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
    bin.install_symlink "phrase-cli" => "phrase"

    generate_completions_from_executable(bin/"phrase", "completion", base_name: "phrase", shells: [:bash])
  end

  test do
    assert_match "ERROR: no targets for download specified", shell_output("#{bin}/phrase pull 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/phrase version")
  end
end