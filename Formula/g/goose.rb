class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https:pressly.github.iogoose"
  url "https:github.compresslygoosearchiverefstagsv3.22.0.tar.gz"
  sha256 "c624faf209caa6d666059882904a4fc90be6e225aeede0cd063bb4b6aa365c90"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bff5886d5b3631fed778353dc634b94ae525229c1318a15a88a3af87c456a8c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8361873d70fb75cc4bf30683aa8454ce62957d6a1958ba578e14c9cff418ac3d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c6a1cfd47a4210947d197d6838b3b239da1b4516629a5ea8a31ee62fc8420ad"
    sha256 cellar: :any_skip_relocation, sonoma:         "876630c334b27c9ce97fe2ced1b1c4b52ef8108fe06d856656a468a79712eddb"
    sha256 cellar: :any_skip_relocation, ventura:        "93995b716629f85044d08224add359444af036bec452242b0cc188787e4dab2b"
    sha256 cellar: :any_skip_relocation, monterey:       "2e93ce78c4c509755eec63035189d3bb40019c6e21d67d5f890c75d53619f6e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12cb0790d3698a472ff189792bc9163cfd25128f95436e3c0671c330f0048c5b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-s -w -X main.version=v#{version}]
    system "go", "build", *std_go_args(ldflags:), ".cmdgoose"
  end

  test do
    output = shell_output("#{bin}goose sqlite3 foo.db status create 2>&1", 1)
    assert_match "goose run: failed to collect migrations", output

    assert_match version.to_s, shell_output("#{bin}goose --version")
  end
end