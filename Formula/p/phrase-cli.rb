class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://ghproxy.com/https://github.com/phrase/phrase-cli/archive/refs/tags/2.15.0.tar.gz"
  sha256 "7915a1b7d76f96825d40698e1e90d8fc0f2d7be2b85326ad9e688f1d59f0f6ff"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e998a5046f144e0eaea60a3a09077440758097f70368c31207e9a790e2597ed6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dec605fb71ebefd0fe310a7c797472fea9a44e1d2c0c68c903d7050dee653780"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e24014be77d4ebb6483edbb07ae1fcac83c8e2151aaadce1f278cfebf5080dad"
    sha256 cellar: :any_skip_relocation, sonoma:         "4dee6bd507cf1ea389b87aece3e3e628bbdd5f0de53ac44a3cce5c14492fb45d"
    sha256 cellar: :any_skip_relocation, ventura:        "a7ce60e1706aaea232441adfee6e1a93db4c436adb0984ff92c2c2e264ac5661"
    sha256 cellar: :any_skip_relocation, monterey:       "44b838257ecf8448324263dd252c2bf52d6410b02651ece7acfc1ab45af83042"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4531c4741a8546e1dcf545b8a845336ad57b48e6d1f8cb040fd3fc3fed63aff9"
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